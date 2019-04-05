# codebuild-php-node
AWS CodeBuild Images for building PHP and Node applications

## Purpose

It is a CodeBuild custom image including PHP and Node.js runtime, based on [AWS CodeBuild curated Docker images](https://github.com/aws/aws-codebuild-docker-images).
The image is used for PHP and JavaScript Project, such as [roots/sage](https://github.com/roots/sage).

## Usage

Prebuild images are available on Dockerhub.

- [shogo82148/codebuild-php-node](https://hub.docker.com/r/shogo82148/codebuild-php-node)

Docker Pull Command:

```
docker pull shogo82148/codebuild-php-node
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
        Image: shogo82148/codebuild-php-node:php7.2-node10
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
