# EKS Cluster Setup with Prometheus Monitoring

The project is organized into several directories for easy management and scalability:

- **eks**: Contains all resources related to the EKS cluster setup, including launch templates and configurations.
- **eks-node**: Focused on configuring the node groups and launch templates for worker nodes.
- **helm_charts**: Contains Helm chart configuration for deploying Prometheus.

### Directories and Files Overview

1. **eks/eks.tf**: Defines the EKS cluster, specifying cluster name, IAM roles, networking, and security settings. The cluster is configured to use a custom Kubernetes version, and logging is enabled for better troubleshooting.

2. **eks-node/eks-launch-template.tf**: Configures the launch template for node groups, specifying instance types, volumes, and additional monitoring settings.

3. **helm_charts/values.yaml**: Custom Helm chart values for deploying Prometheus. It defines replica count, resource requests and limits, remote write configurations, and custom scrape jobs for monitoring various components, such as Istiod and Envoy.

## Key Features of the Setup

### 1. **Amazon EKS Cluster**

The EKS cluster is defined in `eks/eks.tf` using the Terraform `aws_eks_cluster` resource. This file contains important configurations such as:

- **VPC Configuration**: Utilizes specified subnets, private/public endpoint configurations, and security groups for fine-grained network access control.
- **IAM Role**: Configures an IAM role (`role_eks`) to define cluster permissions.
- **Encryption**: Uses AWS KMS for encrypting Kubernetes secrets, ensuring data security.
- **Addons**: Adds support for `vpc-cni` to enhance the networking experience.

### 2. **EKS Node Group Configuration**

The node groups are managed in the `eks-node/node-group.tf` using the `aws_eks_node_group` resource:

- **Scaling**: Supports different capacities (min, max, and desired sizes) for scalability.
- **Launch Template Integration**: Uses launch templates (`eks-launch-template.tf`) for consistent worker node configuration.
- **Auto-healing**: `force_update_version` ensures that nodes are updated automatically, increasing cluster stability.

### 3. **Helm Charts for Monitoring (Prometheus)**

The `helm_charts/values.yaml` configures Prometheus, providing observability for your cluster:

- **Image Configuration**: Specifies the Docker image and repository, along with pull policy.
- **NodeSelector and Resource Limits**: Ensures that Prometheus runs on nodes labeled for monitoring workloads and has appropriate CPU/memory limits.
- **Remote Write Configuration**: Allows Prometheus to write metrics to external systems like Thanos.
- **Scrape Jobs**: Custom scrape configurations for different components such as Prometheus itself, Istiod, Envoy, and the Kubernetes API server, providing full visibility into the cluster.

### 4. **Security and Best Practices**

- **VPC and Security Groups**: EKS and its nodes are placed within specific subnets (`eks/variables.tf`) to control network accessibility.
- **IAM Roles**: Proper IAM roles are configured to grant least privilege access, which is essential for both the control plane and worker nodes.
- **Launch Template Optimizations**: Optimizations include the ability to select EBS volume types and encryption settings.

## Deployment Instructions

### Prerequisites

1. **Terraform**: Ensure Terraform is installed (v0.14+ recommended).
2. **AWS CLI**: Configure the AWS CLI with credentials and default region.
3. **Helm**: Make sure Helm is installed for deploying the charts.

### Steps to Deploy

1. **Initialize Terraform**:
   ```sh
   terraform init
   ```
2. **Validate the Terraform Configuration**:
   ```sh
   terraform validate
   ```
3. **Apply the Terraform Configuration**:
   ```sh
   terraform apply
   ```
4. **Install Prometheus using Helm**:
   Navigate to the `helm_charts` directory and run:
   ```sh
   helm install prometheus ./ -f values.yaml
   ```

### Customizing the Configuration

- **Node Group Configuration**: You can adjust the scaling properties (`min_size`, `max_size`, `desired_size`) in `eks-node/node-group.tf` to fit your needs.
- **Prometheus Settings**: Modify `values.yaml` in the `helm_charts` directory to change resource limits, scrape configurations, and retention settings.

## Best Practices

1. **Security**: Ensure that sensitive information, such as KMS keys and access tokens, is properly managed using SSM Parameter Store or AWS Secrets Manager.
2. **Scaling**: Set reasonable limits and requests for your Prometheus instances to avoid resource exhaustion.
3. **Monitoring and Alerts**: Set up alerts for key metrics to stay informed about the health of the cluster.

## Conclusion

This setup provides a solid foundation for managing an Amazon EKS cluster with Prometheus monitoring. The use of Terraform, along with Helm, makes it easy to deploy, manage, and scale your infrastructure while maintaining observability. Each component is modularized to ensure that changes are easily managed, whether scaling node groups or updating Helm configurations for observability.

