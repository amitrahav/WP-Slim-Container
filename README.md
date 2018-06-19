# PHP-FPM slim docker for WP usage
> this is a slim php-fpm ready to build on codeBuild and use wordpress apps.

## In the box

1. [PHP-7.1](https://hub.docker.com/_/php/)

2. [Composer](https://getcomposer.org/)

3. [Wp cli](https://wp-cli.org/)

4. mysql-client (not a server)

5. Ready to build with codeBuild AWS

6. [Postfix](http://www.postfix.org/)

## CodeBuild Usage

* Configure codeBuild project with aws/codebuild/docker:1.12.1 as current image.
* Enable Privileged for building new docker images (under Environment options).
* Make sure to Allow AWS CodeBuild to modify this service role so it can be used with this build project.
* Create ECS repository
* Define Env vars:
    * IMAGE_REPO_NAME - Elastic Container Service Repository Name
    * AWS_ACCOUNT_ID - your account ID
    * IMAGE_TAG - probebly should be latest
    * AWS_DEFAULT_REGION - default region
