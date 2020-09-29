# Docker image to deploy from CI to Amazon EKS

This is yet another docker image with `aws`, `docker`, `docker-compose`, `helm` & `kubectl` command line tools made for automated deployments.

The idea is that you should own an image which you use in your CI for deployment, so we have our own copy too.

Use this one at your own risk!

## Details

Tags:
  * `latest`
	* alpine `3.12.0`
    * aws `2.0.12`
    * docker `19.03.8`
    * docker-compose `1.25.5`
    * helm `3.2.0`
    * kubectl `1.18.2`
  * `2.0.12`
    * aws `2.0.12`
    * docker `19.03.8`
    * docker-compose `1.25.5`
    * helm `3.2.0`
    * kubectl `1.18.2`

## Docker pull

```shell
docker pull teamtito/aws-k8s-deploy:latest
```
