#!/bin/bash

wget https://github.com/microsoft/Git-Credential-Manager-Core/releases/download/v2.0.498/gcmcore-linux_amd64.2.0.498.54650.tar.gz
tar -xzf gcmcore-linux_amd64.2.0.498.54650.tar.gz -C ~/.local/bin
rm gcmcore-linux_amd64.2.0.498.54650.tar.gz
git-credential-manager configure
