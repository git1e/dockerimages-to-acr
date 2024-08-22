# push image to aliyun acr
## 1、权限配置
### 1.1 Github Action权限配置
项目-->settings-->actions-->general-->Workflow permissions
![alt text](img/image.png)
### 1.2 阿里云ACR权限配置
略
### 1.3 github 配置ACR 用户/密码 secrets
项目-->settings-->Actions secrets and variables-->Actions--->Repository secrets
![alt text](img/secrets_image.png)
## 2、将镜像信息写入img-list.txt问中
## 3、github action中执行脚本,将镜像推送到阿里云ACR
