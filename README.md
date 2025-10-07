# Trend-Tasks-App
Trendify online shopping website is basically created in React library and lightweight to simplify the complex app .
 
> Console final output
<img width="1355" height="675" alt="image" src="https://github.com/user-attachments/assets/20547e64-bd16-46d8-a45e-0a962efd8436" />

# Prerequisite for the website to run
- Amazon Ec2 server
- Dockerhub
- Terraform
- Jenkins
- Kubernetes Cluster
- Prometheus and grafana
- Github

  # Source for the tools
  

| Category	| Tools/Services |	Purpose |
|----------|----------------|---------|
| Version Control	| Git , GitHub	| Store and manage source code; trigger pipeline via webhooks |
| Containerization	| Docker ,DockerHub |	Build container images, store them, and deploy |
| IaC	| Terraform |	Provision AWS infrastructure (VPC, EC2, IAM) automatically |
| CI/CD	| Jenkins |	Automate build push, and deployment process |
| Orchestration	| Kubernetes | AWS EKS	Deploy and manage app containers in production |
| Monitoring	| Prometheus Grafana (or alternative)	| Track app and cluster health |
| Cloud Provider	| AWS	| Host infrastructure (EC2, EKS, VPC, IAM) |



# Step - 1
<img width="48" height="48" src="https://img.icons8.com/fluency/48/docker.png" alt="docker"/>

# Createing Dockerfile
After createing the docker file we need to check the application is running on the localhost with the port no 3000

` docker build -t trend-app:latest .`
`docker run -d -p 3000:80 --name trend-app trend-app:latest `

# Step - 2
<img width="32" height="32" src="https://img.icons8.com/external-kmg-design-outline-color-kmg-design/32/external-cloud-server-web-hosting-kmg-design-outline-color-kmg-design.png" alt="external-cloud-server-web-hosting-kmg-design-outline-color-kmg-design"/>

# Createing EC2 Server 
On this Ec2 server we need to provide the `aws configure` and install the terraform registory 
We created the main.tf on the using userdata we createing jenkins. `jenkins pre-required java and jenkins run on port no 8080`
# Terraform file created Server
<img width="1366" height="641" alt="image" src="https://github.com/user-attachments/assets/e57a25e7-36c3-4efb-ba04-8646cd776940" />

# Jenkins_Server
<img width="48" height="48" src="https://img.icons8.com/color/48/jenkins.png" alt="jenkins"/>
<img width="1366" height="641" alt="image" src="https://github.com/user-attachments/assets/17f2b4e1-43c2-4c54-bd6d-717c54d78d14" />
# jenkins_Running
<img width="1366" height="641" alt="image" src="https://github.com/user-attachments/assets/bdb67c94-0e38-4e9f-90dd-8f9d9d3ff000" />

# Step - 3
<img width="311" height="162" alt="image" src="https://github.com/user-attachments/assets/32626503-1ce0-4652-942e-be4a1ec2982f" />

# Createing Dockerhub
Createing the empty docker repo in dockerhub and given public access
<img width="1366" height="641" alt="image" src="https://github.com/user-attachments/assets/bfafe2d2-5b2c-41db-afed-3c6c7cb95482" />

# Step - 4
On the Jenkins Server we installed EKS Cluster by running the commands are  `- curl --silent --location "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" -o eksctl.tar.gz
   - tar -xzf eksctl.tar.gz
   - sudo mv eksctl /usr/local/bin
   - eksctl version
   - kubectl version --client
   - aws sts get-caller-identity
   - sudo eksctl create cluster   --name trend-tasks-app   --region us-east-1   --nodegroup-name trend-tasks-nodes   --node-type t3.medium   --nodes 2`

## EKS Cluster Running With Two nodes
<img width="1366" height="641" alt="image" src="https://github.com/user-attachments/assets/fc942743-c254-4d09-8d38-8eb27acc96bd" />

## Upon nodes
<img width="1366" height="641" alt="image" src="https://github.com/user-attachments/assets/5d8a5405-6f11-4463-a532-4cc1ce31247b" />




# Step - 5
On the jenkins server opened on the Console UI . And adding pluging to deploy k8s cluster
`k8s`
`Docker`
`pipeline stageview`
Adding the credential to access the dockerhub and EKS Cluser
<img width="1366" height="641" alt="image" src="https://github.com/user-attachments/assets/cf1f6f30-0d9f-48f7-a544-6d62c235f1f2" />

# Step - 6

Createing Project on the jenkins server using jenkins pipeline . In this pipeline cover the 5 stages `Checkout ,	Build Docker Image ,	Push to DockerHub ,	Configure Kubeconfig ,	Deploy to EKS`
<img width="1366" height="641" alt="image" src="https://github.com/user-attachments/assets/6c45a558-c2ea-4586-9b07-982856ed2caa" />

# Step - 7 

We used github for the version control system in the porject repo we created webhooks for the jekins to auto trigger if there is any code changes jenkins pipeline will trigger auto metically and code deploy to the EKS Cluster .
<img width="1366" height="641" alt="image" src="https://github.com/user-attachments/assets/b5dbedd7-12fa-41a6-8241-8c3fc4eb8648" />

# Step - 8
We Created K8s yml for deploy and service . `in that Service to used port forward from container port 80 to 3000 `

# Step - 9
By pushing the code changes in VCS it trigger automatically pipeline .
<img width="1366" height="641" alt="image" src="https://github.com/user-attachments/assets/d5b9990d-9bfe-4aef-886e-c40f4c098989" />

# Step - 10

If the above pipeline is succefull . it will deploy automatically in EKS cluster by verfiying using the commands are 

<img width="1254" height="141" alt="image" src="https://github.com/user-attachments/assets/8be2c21c-eabb-458b-ab3f-ced60f9dbd82" />

# Step - 11
On the svc it will provide the external ip using this our application is run on succesfully .

<img width="1355" height="675" alt="image" src="https://github.com/user-attachments/assets/20547e64-bd16-46d8-a45e-0a962efd8436" />

# Step - 12
We created on more server for Monitoring tools are prometheus and grafana .
installed steps are 

<img width="659" height="218" alt="image" src="https://github.com/user-attachments/assets/7ca9d37c-8cfa-4c16-bf30-fe258c37972c" />

Prometheus can be run on port no 9090 we need to open the port on the server

<img width="1366" height="641" alt="image" src="https://github.com/user-attachments/assets/0d4b17fb-fe15-41b2-92fa-641404404488" />

we installed alert manager . if any issue faceing the cluster alert manager will trigger the congifure email .

<img width="730" height="372" alt="image" src="https://github.com/user-attachments/assets/016cec3f-52ac-4edd-bc0c-bc6de89a9042" />

We need to change the prometheus.yml in that we changed the alert manager name and host ip address for our EKS cluster.

<img width="1052" height="535" alt="image" src="https://github.com/user-attachments/assets/971b7467-6ff6-4e25-899c-426f6ff66e5a" />

# Step - 13
Installing grafana for better visualization tool

  - wget https://dl.grafana.com/grafana/release/12.2.0/grafana_12.2.0_17949786146_linux_amd64.tar.gz
  - tar -zxvf grafana_12.2.0_17949786146_linux_amd64.tar.gz~
  - cd grafana-12.2.0/
  - cd bin
  - ./grafana-server &

    `Grafana runs on the port no 3000` we need to open the port no 3000 on the server .

    <img width="1366" height="641" alt="image" src="https://github.com/user-attachments/assets/f6084750-c888-4fc2-9de6-b86140aea47e" />

# step - 14 
Git commands
git add .
git commit -m "final commit "
git push origin main

