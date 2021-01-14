# Docker image to deploy from CI to Amazon EKS

This is yet another docker image with `aws`, `docker`, `docker-compose`, `helm` & `kubectl` command line tools made for automated deployments.

The idea is that you should own an image which you use in your CI for deployment, so we have our own copy too.

Use this one at your own risk!

## Details

Tags:
  * `2.1.18`
    * aws `2.1.18`
	* alpine `3.12.3`
	* docker `20.10.2`
    * docker-compose `1.27.4`
	* kubectl `1.20.2`
	* helm `3.5.0`
  * `2.1.17`
    * aws `2.1.17`
	* helm `3.4.2`
	* kubectl `1.20.1`
	* alpine `3.12.3`
	* docker `20.10.2`
  * `2.0.58`
	* alpine `3.12.1`
    * aws `2.0.58`
    * docker `19.03.13`
    * docker-compose `1.27.4`
    * helm `3.3.4`
    * kubectl `1.19.3`
  * `2.0.52`
	* alpine `3.12.0`
    * aws `2.0.52`
    * docker `19.03.13`
    * docker-compose `1.27.4`
    * helm `3.3.4`
    * kubectl `1.19.2`
  * `2.0.12`
    * aws `2.0.12`
    * docker `19.03.13`
    * docker-compose `1.25.5`
    * helm `3.2.0`
    * kubectl `1.18.2`

## Docker pull

```shell
docker pull quay.io/evl.ms/aws-k8s-deploy:2.1.17
```
