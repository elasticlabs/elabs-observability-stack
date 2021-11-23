# elabs-observability-stack
Simple yet fully capable Prometheus - Grafana - Tempo - cAdvisor based observability composition. For HTTPS reverse proxy see [Elasticlabs HTTPS Nginx Proxy](https://github.com/elasticlabs/https-nginx-proxy-docker-compose).

<p>
  <img src="https://raw.githubusercontent.com/elasticlabs/elabs-observability-stack/main/architecture.png" alt="TEAMEngine architecture" width="600px">
</p>

**Table Of Contents:**
  - [Docker environment preparation](#docker-environment-preparation)
  - [TEAMEngine deployment preparation](#grafana-deployment-preparation)
  - [Stack deployment and management](#stack-deployment-and-management)

----

## Docker environment preparation 
This stack is meant to be deployed behind an automated NGINX based HTTPS proxy. The recommanded automated HTTPS proxy for this stack is the [Elasticlabs HTTPS Nginx Proxy](https://github.com/elasticlabs/https-nginx-proxy-docker-compose). This composition repository assumes you have this environment :
* Working HTTPS Nginx proxy using Let'sencrypt certificates
* A local docker LAN network called `revproxy_apps` for hosting your *bubble apps* (Nginx entrypoint for each *bubble*). 

**Once you have a HTTPS reverse proxy**, navigate to the  [next](#grafana-deployment-preparation) section.


## Grafana deployment preparation
* Choose & register a DNS name (e.g. `your-awesome-domain.ltd`). Make sure it properly resolves from your server using `nslookup`commands.
* Carefully create / choose an appropriate directory to group your applications GIT reposities (e.g. `~/AppContainers/`)
* GIT clone this repository `git clone https://github.com/elasticlabs/grafana-compose.git`

**Configuration**
* **Rename `.env-changeme` file into `.env`** to ensure `docker-compose` gets its environement correctly.
* Modify the following variables in `.env-changeme` file :
  * `TE_VHOST=` : replace `your-domain.ltd` with your choosen subdomain for grafana.
  * `LETSENCRYPT_EMAIL=` : replace `email@mail-provider.ltd` with the email address to get notifications on Certificates issues for your domain. 

## Stack deployment and management
**Deployment**
* Get help : `sudo make help`
* Bring up the whole stack : `sudo make build && sudo make up`
* Head to **`http://your-awesome-domain.ltd/grafana`** and enjoy Grafana observability!

**Useful management commands**
* Go inside a container : `sudo docker-compose exec -it <service-id> bash` or `sh`
* See logs of a container: `sudo docker-compose logs <service-id>`
* Monitor containers : `sudo docker stats` or... use portainer!
