#!/bin/sh

cat <<'EOS' > README.md
# codebuild-php-node
AWS CodeBuild Images for building PHP and Node applications

## Purpose

It is a CodeBuild custom image including PHP and Node.js runtime, based on [AWS CodeBuild curated Docker images](https://github.com/aws/aws-codebuild-docker-images).
The image is optimized for PHP and JavaScript Project, such as [roots/sage](https://github.com/roots/sage).

## Usage

Pre-build images are available on DockerHub.

- [shogo82148/codebuild-php-node](https://hub.docker.com/r/shogo82148/codebuild-php-node)

Docker Pull Command:

```bash
EOS

for STANDARD in 4.0 3.0 2.0 1.0
do
    echo \# standard $STANDARD based >> README.md
    for PHP in 7.4 7.3 7.2
    do
        for NODE in 14 12 10
        do
        (
            echo docker pull shogo82148/codebuild-php-node:php$PHP-node$NODE-standard-$STANDARD >> README.md
            cd "ubuntu/$STANDARD" && \
            echo updating "php$PHP" "node$NODE" "standard-$STANDARD" >&2 && \
            ./update.pl "$PHP" "$NODE"
        ) || exit 1
        done
    done
    echo >> README.md
done

for AL2 in 3.0 2.0 1.0
do
    echo \# amazonlinux2-x86_64-amazonlinux2 $AL2 based >> README.md
    for PHP in 7.4 7.3 7.2
    do
        for NODE in 14 12 10
        do
        (
            echo docker pull shogo82148/codebuild-php-node:php$PHP-node$NODE-amazonlinux2-$AL2 >> README.md
            cd "al2/$AL2" && \
            echo updating "php$PHP" "node$NODE" "amazonlinux2-$AL2" >&2 && \
            ./update.pl "$PHP" "$NODE"
        ) || exit 1
        done
    done
    echo >> README.md
done

cat <<'EOS' >> README.md
```

PHP 7.1 images are no longer mantained.
They remain in this repository as a reference for the contents of these images.

### An Example of CloudFormation Template for Creating CodeBuild Project

```yaml
  CodeBuildProject:
    Type: AWS::CodeBuild::Project
    Properties:
      Artifacts:
        Type: NO_ARTIFACTS
      Environment:
        ComputeType: BUILD_GENERAL1_SMALL
        Image: shogo82148/codebuild-php-node:php7.4-node14-standard-4.0
        Type: LINUX_CONTAINER
      ServiceRole: !GetAtt CodeBuildRole.Arn
      Source:
        Type: GITHUB
        ReportBuildStatus: true
        Location: https://github.com/shogo82148/codebuild-php-node
      TimeoutInMinutes: 10
  CodeBuildRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              Service: codebuild.amazonaws.com
            Action: "sts:AssumeRole"
      Path: "/"
      Policies:
        - PolicyDocument:
            Statement:
              - Action:
                  - logs:CreateLogGroup
                  - logs:CreateLogStream
                  - logs:PutLogEvents
                  - logs:DescribeLogStreams
                Effect: Allow
                Resource: arn:aws:logs:*:*:*
            Version: 2012-10-17
          PolicyName: cloudWatchLogsPolicy
```

## RELATED WORK

- https://github.com/aws/aws-codebuild-docker-images
- https://github.com/docker-library/php
- https://github.com/nodejs/docker-node
EOS
