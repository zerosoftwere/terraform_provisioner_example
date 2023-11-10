# Terrafom Provisioner Example

## About Project

Creates and configures EC2 web server using provisioners

## How to use

This project uses the **AWS** provider

- Setup your aws-cli configuration
- Generete your ssh keys using ssh-keygen on linux and mac (on windows ;( where there is will, there is way))
- Set the ssh key pair paths in your `terraform.tfvaras` (file not provided so you would have to create it) or cli equivalent
- Apply and wait for the magic to happen