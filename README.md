# SPIFFE examples 

This repository contains infrastructure for development and demos as well as automated demos for each SPIRE release
 
## Demonstrations

**[simple_verification](simple_verification) - SVID Verification with Ghostunnel**

This demo shows a Ghostunnel connection validating SPIFFE certificates.

**[rosemary](rosemary) - UNIX Attestation and Ghostunnel Verification**

Demonstrates two workloads communicating over mutually authenticated Ghostunnel using SVIDs generated through UNIX attestation by UID. 

**[beatrice](beatrice) - Kubernetes Attestation and Ghostunnel verification**

Demonstrates two workloads communicating over mutually authenticated Ghostunnel endpoints using SVIDs automatically provisioned to an attested Kubernetes Pod. 

**[cadfael](cadfael) - AWS Attestation and Envoy Verification**

Demonstrates two workloads communicating via mutually authenticated Envoys using SVIDs generated through AWS instance attestation. 

**[drew](drew) - Server and Agent Scale and Performance**

Demonstrates 100 workloads on 100 servers managed by one spire-server

**[dupin](dupin) - nginx with SPIFFE support**

Demonstrates the use of the SPIFFE Workload API to automatically get X.509 certificates natively in nginx, with no helper. Connections are accepted or rejected based on allowed SPIFFE IDs.

**[java-spiffe](java-spiffe) - java with SPIFFE support**

Demonstrates the use of the SPIFFE Workload API to dynamically update the X509 certificates of a custom KeyStore in a Java Security Provider. Connections are established using mTLS validating SPIFFE IDs

**[java-keystore-tomcat](java-keystore-tomcat-demo) - Tomcat using a SPIFFE based KeyStore**

Demonstrates two Tomcats using a SPIFFE based KeyStore and TrustStore that handles SVID certificates that gets from the WorkloadAPI. Connections are established using mTLS validating SPIFFE IDs.


**[java-spiffe-federation-jboss](java-spiffe-federation-jboss) - JBOSS and NGINX on Federated Trust Domains**

Shows a Federation scenario with two trust-domains, one having a JBOSS Wildfly Server connecting to a PostgreSQL database proxied by a NGNIX running on the other trust-domain. 

**[spiffe-envoy-agent](spiffe-envoy-agent)**

Demonstrates using Envoy proxy to facilitate secure communication using mTLS and TLS+JWT between two federated trust domains. Envoy proxy receives and validates secrets via an SPIFFE Envoy Agent implementing the Envoy SDS and External Auth APIs and providing the glue between Envoy and the SPIRE Agent.

## Infrastructure

**[vagrant_k8s](vagrant_k8s) - Local Kubernetes with Vagrant**

Creates a Kubernetes master and >=1 node in separate Vagrant VMs.

**[vagrant_db](vagrant_db) - Local MariaDB "bare metal" with Vagrant**

**[ec2](ec2) - AWS EC2 with Terraform**

Provisions a VPC with three EC2 instances with proper IAM instance roles for the aws-resolver plugin.
