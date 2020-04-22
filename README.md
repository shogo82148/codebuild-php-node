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
# standard 4.0 based
docker pull shogo82148/codebuild-php-node:php7.4-node14-standard-4.0
docker pull shogo82148/codebuild-php-node:php7.4-node12-standard-4.0
docker pull shogo82148/codebuild-php-node:php7.4-node10-standard-4.0
docker pull shogo82148/codebuild-php-node:php7.3-node14-standard-4.0
docker pull shogo82148/codebuild-php-node:php7.3-node12-standard-4.0
docker pull shogo82148/codebuild-php-node:php7.3-node10-standard-4.0
docker pull shogo82148/codebuild-php-node:php7.2-node14-standard-4.0
docker pull shogo82148/codebuild-php-node:php7.2-node12-standard-4.0
docker pull shogo82148/codebuild-php-node:php7.2-node10-standard-4.0
docker pull shogo82148/codebuild-php-node:php7.1-node14-standard-4.0
docker pull shogo82148/codebuild-php-node:php7.1-node12-standard-4.0
docker pull shogo82148/codebuild-php-node:php7.1-node10-standard-4.0

# standard 3.0 based
docker pull shogo82148/codebuild-php-node:php7.4-node14-standard-3.0
docker pull shogo82148/codebuild-php-node:php7.4-node12-standard-3.0
docker pull shogo82148/codebuild-php-node:php7.4-node10-standard-3.0
docker pull shogo82148/codebuild-php-node:php7.3-node14-standard-3.0
docker pull shogo82148/codebuild-php-node:php7.3-node12-standard-3.0
docker pull shogo82148/codebuild-php-node:php7.3-node10-standard-3.0
docker pull shogo82148/codebuild-php-node:php7.2-node14-standard-3.0
docker pull shogo82148/codebuild-php-node:php7.2-node12-standard-3.0
docker pull shogo82148/codebuild-php-node:php7.2-node10-standard-3.0
docker pull shogo82148/codebuild-php-node:php7.1-node14-standard-3.0
docker pull shogo82148/codebuild-php-node:php7.1-node12-standard-3.0
docker pull shogo82148/codebuild-php-node:php7.1-node10-standard-3.0

# standard 2.0 based
docker pull shogo82148/codebuild-php-node:php7.4-node14-standard-2.0
docker pull shogo82148/codebuild-php-node:php7.4-node12-standard-2.0
docker pull shogo82148/codebuild-php-node:php7.4-node10-standard-2.0
docker pull shogo82148/codebuild-php-node:php7.3-node14-standard-2.0
docker pull shogo82148/codebuild-php-node:php7.3-node12-standard-2.0
docker pull shogo82148/codebuild-php-node:php7.3-node10-standard-2.0
docker pull shogo82148/codebuild-php-node:php7.2-node14-standard-2.0
docker pull shogo82148/codebuild-php-node:php7.2-node12-standard-2.0
docker pull shogo82148/codebuild-php-node:php7.2-node10-standard-2.0
docker pull shogo82148/codebuild-php-node:php7.1-node14-standard-2.0
docker pull shogo82148/codebuild-php-node:php7.1-node12-standard-2.0
docker pull shogo82148/codebuild-php-node:php7.1-node10-standard-2.0

# standard 1.0 based
docker pull shogo82148/codebuild-php-node:php7.4-node14-standard-1.0
docker pull shogo82148/codebuild-php-node:php7.4-node12-standard-1.0
docker pull shogo82148/codebuild-php-node:php7.4-node10-standard-1.0
docker pull shogo82148/codebuild-php-node:php7.3-node14-standard-1.0
docker pull shogo82148/codebuild-php-node:php7.3-node12-standard-1.0
docker pull shogo82148/codebuild-php-node:php7.3-node10-standard-1.0
docker pull shogo82148/codebuild-php-node:php7.2-node14-standard-1.0
docker pull shogo82148/codebuild-php-node:php7.2-node12-standard-1.0
docker pull shogo82148/codebuild-php-node:php7.2-node10-standard-1.0
docker pull shogo82148/codebuild-php-node:php7.1-node14-standard-1.0
docker pull shogo82148/codebuild-php-node:php7.1-node12-standard-1.0
docker pull shogo82148/codebuild-php-node:php7.1-node10-standard-1.0

# amazonlinux2-x86_64-standard 3.0 based
docker pull shogo82148/codebuild-php-node:php7.4-node14-al2-3.0
docker pull shogo82148/codebuild-php-node:php7.4-node12-al2-3.0
docker pull shogo82148/codebuild-php-node:php7.4-node10-al2-3.0
docker pull shogo82148/codebuild-php-node:php7.3-node14-al2-3.0
docker pull shogo82148/codebuild-php-node:php7.3-node12-al2-3.0
docker pull shogo82148/codebuild-php-node:php7.3-node10-al2-3.0
docker pull shogo82148/codebuild-php-node:php7.2-node14-al2-3.0
docker pull shogo82148/codebuild-php-node:php7.2-node12-al2-3.0
docker pull shogo82148/codebuild-php-node:php7.2-node10-al2-3.0
docker pull shogo82148/codebuild-php-node:php7.1-node14-al2-3.0
docker pull shogo82148/codebuild-php-node:php7.1-node12-al2-3.0
docker pull shogo82148/codebuild-php-node:php7.1-node10-al2-3.0

# amazonlinux2-x86_64-standard 2.0 based
docker pull shogo82148/codebuild-php-node:php7.4-node14-al2-2.0
docker pull shogo82148/codebuild-php-node:php7.4-node12-al2-2.0
docker pull shogo82148/codebuild-php-node:php7.4-node10-al2-2.0
docker pull shogo82148/codebuild-php-node:php7.3-node14-al2-2.0
docker pull shogo82148/codebuild-php-node:php7.3-node12-al2-2.0
docker pull shogo82148/codebuild-php-node:php7.3-node10-al2-2.0
docker pull shogo82148/codebuild-php-node:php7.2-node14-al2-2.0
docker pull shogo82148/codebuild-php-node:php7.2-node12-al2-2.0
docker pull shogo82148/codebuild-php-node:php7.2-node10-al2-2.0
docker pull shogo82148/codebuild-php-node:php7.1-node14-al2-2.0
docker pull shogo82148/codebuild-php-node:php7.1-node12-al2-2.0
docker pull shogo82148/codebuild-php-node:php7.1-node10-al2-2.0

# amazonlinux2-x86_64-standard 1.0 based
docker pull shogo82148/codebuild-php-node:php7.4-node14-al2-1.0
docker pull shogo82148/codebuild-php-node:php7.4-node12-al2-1.0
docker pull shogo82148/codebuild-php-node:php7.4-node10-al2-1.0
docker pull shogo82148/codebuild-php-node:php7.3-node14-al2-1.0
docker pull shogo82148/codebuild-php-node:php7.3-node12-al2-1.0
docker pull shogo82148/codebuild-php-node:php7.3-node10-al2-1.0
docker pull shogo82148/codebuild-php-node:php7.2-node14-al2-1.0
docker pull shogo82148/codebuild-php-node:php7.2-node12-al2-1.0
docker pull shogo82148/codebuild-php-node:php7.2-node10-al2-1.0
docker pull shogo82148/codebuild-php-node:php7.1-node14-al2-1.0
docker pull shogo82148/codebuild-php-node:php7.1-node12-al2-1.0
docker pull shogo82148/codebuild-php-node:php7.1-node10-al2-1.0

```

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
