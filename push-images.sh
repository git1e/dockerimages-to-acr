#!/bin/bash
#push google or coreos images to   aliyun acr.

# 登录dockerhub,登录docker的用户名和密码在Secrets中设置
aliyun_acr_registry="registry.cn-shanghai.aliyuncs.com"
aliyun_acr_namespace="sh-docker-images"
echo ${ALIYUN_ACR_PASSWORD}|docker login --username=${ALIYUN_ACR_USER} --password-stdin  ${aliyun_acr_registry}
cat img-list.txt
while IFS= read -r image; do  
    # 跳过空行  
    if [ -z "$image" ]; then  
        continue  
    fi  
    # 检查是否是注释行  
    if [[ "$image" =~ ^[[:space:]]*# ]]; then  
        echo "Skipping comment line: $image"  
        continue  
    fi  
  	datetime=`date +%Y-%m-%d_%H:%M:%S`
    # image:tag
	imagename=$(echo ${image} |awk -F'/' '{print $NF}')
	target_image_name=${aliyun_acr_registry}/${aliyun_acr_namespace}/${imagename}

    echo "pull ${image}"
	docker pull ${image} || {
        echo "${datetime} Failed to pull ${image}" >> push.log
        continue
    }
    # tag
    echo "tag ${image} to ${target_image_name}"
	docker tag ${image} ${target_image_name} || {
        echo "${datetime} Failed to tag ${image}" >> push.log
        continue
    }
	# push到阿里云仓库
	docker push ${target_image_name}
	if [ $? -eq 0 ]
	then
		echo "${datetime} push ${image} to ${target_image_name} success">>push.log
        # 将${target_image_name} 追加到 acr-image-list.txt
        grep -q ${target_image_name} acr-image-list.txt || echo ${target_image_name} >> acr-image-list.txt
	else
		echo "${datetime} push ${image} to ${target_image_name} failed">>push.log
	fi
done < img-list.txt
ls -lh
cat push.log
