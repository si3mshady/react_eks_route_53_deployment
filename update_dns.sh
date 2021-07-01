#!/bin/bash 
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | \
            tar xz -C /tmp  
            mv /tmp/eksctl /usr/local/bin                
            
            instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)

            aws ec2 modify-instance-metadata-options \
            --instance-id $instance_id \
            --http-put-response-hop-limit 2 \
            --http-endpoint enabled \
            --region us-east-1 

            # python3 ./deployment_handler.py && namespace=$(kubectl get ns | grep -i si3ms |  awk '{print $1}') && \
            
            loadBalancerURL=$(kubectl get svc  | grep LoadBalancer | awk '{print $4}') && \
            
            sed -i 's/a.example.com/codepen.si3mshady.com/g' CNAME.json || true && echo 'pass'  && \
            sed -i "s/8.8.8.8/$loadBalancerURL/g" CNAME.json  || true && echo 'pass'  && \

            aws route53 change-resource-record-sets \
            --hosted-zone-id 88888 \
            --change-batch file://CNAME.json   