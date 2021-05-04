# Docker image to deploy from CI to Amazon EKS

This is yet another docker image with `aws`, `docker`, `docker-compose`, `helm` & `kubectl` command line tools made for automated deployments.

The idea is that you should own an image which you use in your CI for deployment, so we have our own copy too.

Use this one at your own risk!

## Details

Tags:
  * `2.2.1`
    * aws `2.2.1`
    * docker `20.10.6`
    * docker-compose `1.29.1`
    * docker-buildx `0.5.1`
    * helm `3.5.4`
    * kubectl `1.21.0`
  * `2.1.32`
    * aws `2.1.32`
    * alpine `3.13.3`
    * docker `20.10.5`
    * docker-compose `1.28.6`
    * docker-buildx `0.5.1`
    * kubectl `1.20.5`
    * helm `3.5.3`
  * `2.1.24`
    * aws `2.1.23`
    * alpine `3.13.1`
    * docker `20.10.3`
    * docker-compose `1.28.2`
    * kubectl `1.20.2`
    * helm `3.5.2`
  * `2.1.23`
    * aws `2.1.23`
    * alpine `3.13.1`
    * docker `20.10.3`
    * docker-compose `1.28.2`
    * kubectl `1.20.2`
    * helm `3.5.1`
  * `2.0.50`
    * aws `2.0.50`
    * docker `19.03.13`
    * docker-compose `1.27.3`
    * dockerize `0.6.1`
    * helm `3.3.2`
    * kubectl `1.19.2`

## Docker pull

```shell
docker pull teamtito/aws-k8s-deploy:2.2.1
```
