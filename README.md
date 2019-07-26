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
<h1 id="solution">Solution</h1>
<p>In this repository you can see a terraform solution of provisioning an Application stack running Apache Mysql PHP on AWS.</p>
<h3 id="directory-structure">Directory structure</h3>
<p>In my project, I divide Terraform configuration files into three main categories:</p>
<ul>
<li><code>compute</code>: Autoscaling groups (ASG), Application Load Balancer (ALB), ECS, Logs (CloudWatch), RDS fall into this category</li>
<li><code>networking</code>: VPC, Security groups</li>
<li><code>iam</code>:  IAM</li>
</ul>
<p><img src="https://lh3.googleusercontent.com/P9MxtLh06u_hkuqT8-LdzUNtv7nifYFa83U9nD1HRDvFU8gR6y3pejMYDDGlZEUZQxEqX7AihSW8" alt="enter image description here"></p>
<h2 id="implementation">Implementation</h2>
<h4 id="for-networking">For networking</h4>
<ul>
<li>VPC</li>
<li>IGW</li>
<li>Private RT (no internet connected)</li>
<li>Public RT (conncted to IGW)</li>
<li>2 x Private Subnets (in different az) for RDS</li>
<li>2 x Public Subnets (in different az) for webservers</li>
<li>3 x Security groups for ALB, webservers, RDS</li>
<li>DHCP Option set</li>
</ul>
<h4 id="for--rds">For  RDS</h4>
<ul>
<li>Amazon RDS service</li>
</ul>
<h4 id="for-webserver">For Webserver</h4>
<ul>
<li>ECS runnig one service - 2 x tasks run containers on 2 x EC2 into my Public Subnets</li>
<li>For container image I use phpmyadmin/phpmyadmin <a href="https://hub.docker.com/r/phpmyadmin/phpmyadmin">https://hub.docker.com/r/phpmyadmin/phpmyadmin</a></li>
<li>ALB</li>
<li>Auto Scaling Group</li>
</ul>
<h4 id="for--iam">For  IAM</h4>
<ul>
<li>2 x roles and 2 x policy<br>
<img src="https://lh3.googleusercontent.com/89xQi1jbICSFzYs1QLQYzRSN49X-mI5wBiX7qE2-OIzVtRt_L_DrPq5afgZUAH6rZrpzJ5mzCNae" alt="enter image description here"><img src="https://lh3.googleusercontent.com/bWLSYsISoUD4Uwtg8eQTgNcOkVcVPJNt3uypLYQ1edni2svP2zpq41AiNM7VO-O4R_vJTFC92uj6" alt="enter image description here"></li>
</ul>
<h4 id="for--monitoring-i-use-cloud-watch-servise">For  Monitoring I use Cloud Watch Servise</h4>
<p><img src="https://lh3.googleusercontent.com/LzkI9dhf4xQ3T_9qwg4UOajOxurgZojYTHJpFvfQ1bt_XEaSAHIUl8zCSlFJOPPa2-_0L9yF7FAn" alt="enter image description here"><img src="https://lh3.googleusercontent.com/kma0XMP2qYV8KtiommwNGmD4aU6ntbQOn_bccYvOFZDKFD6jIbp9rfOs7fZ6ZC1VkUpwNBxhIQhO" alt="enter image description here"></p>
<h2 id="what-we-expect-to-see-as-a-result">What we expect to see as a result</h2>
<p>When you hit load balancer link, you can see PhpMyAdmin login screen</p>
<p><img src="https://lh3.googleusercontent.com/tY__Tk8OnYhIwe9vs-wiwceaBROl1jLYhITY5KEJyvvD5aEQlN8YMXbg_DOGv9p96voTZGzr2PDT" alt="enter image description here"></p>
<p>Now you can log into MySQL database server.<br>
Username = root<br>
Password = "     "</p>
<ul>
<li>the password is the one you have been asked to provide while applying terraform"<br>
<img src="https://lh3.googleusercontent.com/Y_rpifU_h3DCPM4sf0Qe5OGZ1Z5dE_spqyFiZljpoG9Pw6iyNK9XkpVhSKZLY_tvxLrNC0pqvN9k" alt="enter image description here"></li>
</ul>
<p><img src="https://lh3.googleusercontent.com/Ee9JS6F5taYvO2LjC9iD9LKjncUHgpTUMOkcowBAolSLGIg0fv2DZuc3bKqMeUvA0bmKActtMJMR" alt="enter image description here"></p>

