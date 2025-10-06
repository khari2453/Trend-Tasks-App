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







<img width="48" height="48" src="https://img.icons8.com/color/48/terraform.png" alt="terraform"/>
