# RPort Value Prop


Rewst is an automation company, but we are not an RMM (Remote Monitoring and Management) software company. 

We believe that MSPs already have enough agent-based applications installed, and we do not want to write yet-another one.

We also believe that interaction with endpoints should be done using APIs that interact with the agents already installed in the MSP's environment. Even though Rewst automations often rely on running tasks on endpoints to complete a process, we do not think we need to write our own agent to accomplish this.

However, due to the constant product shuffles in the MSP space, RMM applications are in a state of flux, and product capabilities have been changing rapidly, often losing capabilities in the process. Several of the leading RMM vendors have been re-branding the various RMMs under their ownership and renaming RMM applications, changing an entire product as a version update. These new versions often do not carry the same API capabilities as the "old" versions that they replace. 

MSPs are also moving into 100% cloud-based management of their endpoints, making traditional use of RMM technology largely less important. With Microsoft Intune and Lighthouse, the need to invest in RMM to provide patching, application management, and desired-state enforcement is decreasing. The current downside of Intune and other MDM products, however, is when the need arises to run ad-hoc commands rapidly on endpoints.

Because of these, we needed to identify some ways to provide our MSP partners with a way to deploy or use non-"RMM" applications to perform tasks on endpoints. This includes using Remote Control utilities like ConnectWise ScreenConnect, application management platforms like ImmyBot, and others. When the MSP has one of these applications in their stack, we can use those agents to run these tasks. For the cases where none of these tools are available, we have identified an Open Source application which we feel provides these capabilities for situations where the MSP does not have an alternative workable solution. 

### RMM

With traditional RMM deployments, the MSP obtains a software subscription from their RMM vendor. They consume the application either in cloud-hosted multi-MSP, cloud-hosted single-MSP, or self-hosted configurations. With each of these architectures, there are inherent risks and rewards. 
* Cloud-Hosted Multi-MSP RMM Environments
	* Benefits:
		* No need for the MSP to maintain their own patches.
		* Directly monitored by the RMM vendor.
		* High attention from the RMM vendor is given to the centralized instances in the event of performance, operational, or security issues.
		* Because of the economies of scale, the MSP vendor may be able to deploy mitigating security controls such as Web Application Firewalls (WAFs)
	* Risks:
		* A single compromise of a centralized environment can be catastrophic to many MSPs, along with all of the MSPs' client environments at once.
		* Recovery still falls upon the MSP, and the vendor will be significantly tied up and unable to help on an individual basis.
		* The MSP has zero control over the infrastructure or application.
* Cloud-Hosted Single-MSP RMM Instances
	* Benefits:
		* The vendor (usually) maintains all patching, and performance monitoring.
		* The MSP is shielded from issues that may be caused by someone else on a shared platform.
		* Certain problems may be able to be fixed faster since fixes can be scheduled on the MSP's time
	* Risks:
		* In the event of a compromise, resolution of a single MSP's instance, especially a smaller MSP, may be prioritized lower.
		* The MSP still has little or no control over the infrastructure and application.
		* A compromise can still result in all of an MSP's client base being impacted.
* Self-Hosted RMMs
	* Benefits:
		* The MSP maintains full control of the environment where the RMM is hosted. They are able to do their own troubleshooting and apply their own security controls.
		* A compromise of "someone else's" usually instance doesn't affect the MSP's client base.
	* Risks:
		* A direct compromise of security or availability can still affect all of the MSP's clients.
		* Securing the environment is left up to the MSP, often with little or no guidance from the vendor.
		* MSPs much self-patch software and make their own mitigations against any vulnerabilities in the software, operating system, or other supporting tools in the RMM infrastructure.


### Introducing RPort

[RPort](https://rport.io) is a self-hosted open source remote management solution for Windows, macOS & Linux. It is extremely light-weight compared to most RMMs, requiring only minimal resources to manage thousands of endpoints at a time. Since the resource needs are so limited, this allows us to be innovative with architecting management environments.

RPort, being an application developed in the enterprise space rather than for MSPs, has one important limitation, that we may actually be able to use as a strength. It is designed with single-organization deployment in mind. It does have an organization structure with Groups, but instead of combining end clients into a single instance, we've got options.

The 2021 Kaseya RMM incident showed us that compromise of a single RMM environment by a single agent can spread to multiple clients at once. This is known as a "buffalo jump" attack, where attackers can compromise a single company and then gain access to countless others because of shared infrastructure.

Rewst's plan for RPort is to help the MSP orchestrate the deployment, configuration, and maintenance of RPort server instances. The big difference here is that instead of a single instance of the application that covers the entire customer base, each MSP client would be linked to a dedicated RPort server. This is possible because of the low costs of running these instances, and this helps the MSP achieve isolation between clients. By isolating the instances, even if an RPort server were to be compromised and a whole client's environment attacked as a result, other clients would remain unaffected. 

**How would we achieve this?**

Rewst automations are designed to be deployed at the MSP-level but executed at the client level with no modification. By using our existing Microsoft Azure integration, we can orchestrate the deployment of an RPort server, with its own network infrastructure, unique secrets, credentials, IP addresses, and user accounts for each individual MSP client.

Rewst workflows can then monitor and update the instances and perform all of the automation tasks on the clients' endpoints just like with an RMM platform.

This means that: 
* The MSP remains in control of the RMM instance.
* Management is simplified since Rewst automations are the primary point of interaction.
* Deployment costs are low. Using the smallest VM images possible reduces overhead. There are no other software licenses, such as Windows or SQL server fees.
* By creating an instance of the application per-tenant, MSPs can keep those deployments within specific geographic boundaries where needed for compliances.

**Does this mean that Rewst is building an RMM?**

We are not writing any new software. Our intention is to interact with this technology in the same manner we do with "traditional" RMMs: using REST API calls. Rewst still has no plans to develop an agent, this is just another remote admin method. 

Using existing capabilities with the MS Azure API, we can also perform the server provisioning steps with a crate. This isn't us developing an RMM, it's just a deployment automation. This means that Rewst will build Crates to interact with an MSP's RPort servers should they choose to make use of that technology. Over time, more Rewst workflows and Crates can be built to use RPort to do new and interesting things.

**Security**

Obviously security of a new application is a concern. For full information about the security architecture of RPort, see their [documentation](https://kb.rport.io).
Here are some of the highlights:
* Communication between the server and clients is via an SSH session over HTTP
* The RPort Server supports 2FA for authentication. Even more importantly, we can set up whitelisting so that access to the API is only allowed from Rewst IPs and access to the Admin interface is either blocked completely or protected by IP Whitelist.
* We are also investigating using Cloudflare ZTNA to manage access to the server.


### {{ Internal }}

### Risks

* Rewst now assumes some of the "RMM" Risk
	* This is no different from our current exposure as an app that has full control over the RMMs anyway via their APIs
	* Our stance needs to include how far we go for supporting it.
* RMM Vendors may see us as a threat.
	* Vendors that are slow or unwilling to provide REST APIs to us to run commands on endpoints will lose their hold on customers
	* We are driving a line in the sand: integrate or die.

### Value to Rewst

* Address MSPs who are running RMMs that we can't integrate with due to lack of API support.
* Apply pressure to RMM vendors to integrate or be replaced.
* Replace the value of an RMM over time, justifying the cost of Rewst if Rewst can 100% replace incumbent RMMs with RPort (or other technologies)
* Revenue from charging per-hour fees for RPort servers - Even $5-10 per month per end customer adds up a lot. On top of this, customers will be paying Azure directly for this, potentially using their customers' subscriptions. This means the costs are more easily absorbed or passed onto their clients.
* Show cybersecurity benefits to our clients of using a different type of remote administration tool.

### Solution Development Plan

* Build Debian Image with hooks to get RPort installed via Rewst Automation
* Set per-hour price for the image (Rewst Revenue Generation)
	* $0.02 per hour? (~$15 / month / org)
	* Customer pays MS and we get paid after MS's %
* Build workflows and crates for management of the instances (Tim / ROC)
* Build Integration (Dev)
	* Per-tenant integration setup?
		* Use multi-instancy or normal org mapping?
		* Fields required:
			- Hostname / IP
			- API Key
- Over time with the Rewst Portal system, we can build pages to provide advanced RMM-like functionality, eventually building a next-gen RMM!
- 


### Deployment Steps

* Customer configures Azure Integration
* Rewst workflow to:
	* Create Isolated Azure Resource Group
	* Create VM instance
	* Install and configure RPort


### Project Plan

* [ ] Orchestrate VM Deployment
	* [ ] Automate RPort Server setup via Rewst workflows
	* [ ] Collect Server public/private keys into Rewst for storage
* [ ] Build VM images for Azure Marketplace
	* [ ] Get into marketplace
	* [ ] Decide on per-hour pricing
* [ ] Build Deployment Crates
* [ ] Build Workflows to re-build RPort servers to the latest versions in the event of a failure or upgrade
