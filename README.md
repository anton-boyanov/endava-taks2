---


---

<h1 id="endava-devops-challenge">Endava Devops Challenge</h1>
<h2 id="task-description"><a href="https://github.com/Endava-Sofia/endava-devops-challenge#task-description"></a>Task description</h2>
<ol>
<li>Create public git repository</li>
<li>Choose a free Cloud Service Provider and register a free account with AWS, Azure, etc. or run VirtualBox/VMware Player locally</li>
<li>Provision an Application stack running Apache Mysql PHP, each of the service must run separately on a node - virtual machine or container</li>
<li>Automate the provisioning with the tools you like to use - bash, puppet, chef, Ansible, etc.</li>
<li>Implement service monitoring either using free Cloud Service provider monitoring or Datadog, Zabbix, Nagios, etc.</li>
<li>Automate service-fail-over, e.g. auto-restart of failing service</li>
<li>Document the steps in git history and commit your code</li>
<li>Send us link for the repository containing the finished solution</li>
<li>Present a working solution, e.g. not a powerpoint presentation, but a working demo</li>
</ol>
<h2 id="time-box"><a href="https://github.com/Endava-Sofia/endava-devops-challenge#time-box"></a>Time Box</h2>
<p>The task should be completed within 5 days.</p>
<h1 id="prerequisite">Prerequisite</h1>
<p>Go to <a href="https://www.terraform.io/downloads.html">https://www.terraform.io/downloads.html</a> and download the latest version of Terraform. Also, you need to set <strong>AWS_ACCESS_KEY_ID</strong>, <strong>AWS_SECRET_ACCESS_KEY</strong> environment variables<br>
and <strong>generate public/private rsa key pair</strong> in your working station.</p>
<p>Precaution note, don’t let these values out from your local machine!</p>
<h1 id="slution">Slution</h1>
<p>In this repository you can see a terraform solution of provisioning an Application stack running Apache Mysql PHP on AWS.</p>
<h3 id="directory-structure">Directory structure</h3>
<p>In our project, we divide Terraform configuration files into three main categories:</p>
<ul>
<li><code>compute</code>: Autoscaling groups (ASG), Application Load Balancer (ALB), ECS, Logs (CloudWatch), RDS fall into this category</li>
<li><code>networking</code>: VPC, Security groups</li>
<li><code>iam</code>:  IAM</li>
</ul>

