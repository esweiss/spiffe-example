package main

import (
	"context"
	"crypto/tls"
	"flag"
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
	"os"
)

var (
	addrFlag = flag.String("addr", ":8443", "address to bind to")
	keyFlag  = flag.String("key", "proxy.key.pem", "proxy private key")
	crtFlag  = flag.String("crt", "proxy.crt.pem", "proxy certificate")
	toFlag   = flag.String("to", "echo:8002", "address to proxy to")
	logFlag  = flag.String("log", "", "path to log file")
)

func main() {
	flag.Parse()
	if *logFlag != "" {
		if logFile, err := os.OpenFile(*logFlag, os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0644); err == nil {
			log.SetOutput(logFile)
			defer logFile.Close()
		}
	}
	if err := run(context.Background()); err != nil {
		fmt.Fprintf(os.Stderr, "%+v\n", err)
		os.Exit(1)
	}
}

func run(ctx context.Context) error {
	proxyTransport := *(http.DefaultTransport.(*http.Transport))
	proxyTransport.TLSClientConfig = &tls.Config{
		// While a TERRIBLE idea in general, this is ok for demo purposes.
		// Normally, the proxy would need access to the trust bundle for the
		// trust domain of the echo server, for example by being workload API
		// aware and running alongside an agent.
		InsecureSkipVerify: true,
	}

	proxy := httputil.NewSingleHostReverseProxy(&url.URL{
		Scheme: "https",
		Host:   *toFlag,
	})
	proxy.Transport = &proxyTransport
	proxy.ErrorHandler = func(rw http.ResponseWriter, req *http.Request, err error) {
		log.Printf("http: proxy error: %v", err)
		http.Error(rw, err.Error(), http.StatusBadGateway)
	}

	log.Printf("Proxying from %s to %s...", *addrFlag, *toFlag)
	return http.ListenAndServeTLS(*addrFlag, *crtFlag, *keyFlag, logRequest(proxy))
}

func logRequest(h http.Handler) http.Handler {
	return http.HandlerFunc(func(wr http.ResponseWriter, r *http.Request) {
		log.Printf("REQ: %s %s", r.Method, r.URL)
		h.ServeHTTP(wr, r)
	})
}
