package main

import (
	"bufio"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"strings"
)

func main() {
	if err := run(os.Args); err != nil {
		fmt.Fprintf(os.Stderr, "error: %+v\n", err)
		os.Exit(1)
	}
}

func run(args []string) error {
	var r io.Reader
	if len(args) < 2 {
		r = os.Stdin
	} else {
		r = strings.NewReader(args[1])
	}

	scanner := bufio.NewScanner(r)
	scanner.Scan()
	if err := scanner.Err(); err != nil {
		return err
	}

	m := strings.Split(scanner.Text(), ".")
	if len(m) != 3 {
		return fmt.Errorf("expected 3 parts; got %d\n", m)
	}
	header64 := m[0]
	claims64 := m[1]
	signature64 := m[2]

	headerBytes, err := base64.RawURLEncoding.DecodeString(header64)
	if err != nil {
		return fmt.Errorf("unable to base64 decode header: %v", err)
	}
	claimsBytes, err := base64.RawURLEncoding.DecodeString(claims64)
	if err != nil {
		return fmt.Errorf("unable to base64 decode claims: %v", err)
	}
	if _, err := base64.RawURLEncoding.DecodeString(signature64); err != nil {
		return fmt.Errorf("unable to base64 decode signature: %v", err)
	}

	var header map[string]interface{}
	if err := json.Unmarshal(headerBytes, &header); err != nil {
		return fmt.Errorf("unable to JSON decode header: %v", err)
	}

	var claims map[string]interface{}
	if err := json.Unmarshal(claimsBytes, &claims); err != nil {
		return fmt.Errorf("unable to JSON decode claims: %v", err)
	}

	prettyHeader, err := json.MarshalIndent(header, "", "\t")
	if err != nil {
		return fmt.Errorf("unable to pretty print header: %v", err)
	}

	prettyClaims, err := json.MarshalIndent(claims, "", "\t")
	if err != nil {
		return fmt.Errorf("unable to pretty print claims: %v", err)
	}

	fmt.Println("Header:")
	fmt.Println(string(prettyHeader))
	fmt.Println("Claims:")
	fmt.Println(string(prettyClaims))
	return nil
}
