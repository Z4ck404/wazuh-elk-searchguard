# wazuh-elk-searchguard : 
Wazuh and ELK stack secured with SearchGuard 

# built on the top of : 
- [wazuh-docker 3.13](https://github.com/wazuh/wazuh-docker/tree/3.13)
- [Elk-SearchGuard](https://github.com/deviantony/docker-elk/tree/searchguard)

# Usage : 
`docker-compose up`

Once elasticsearch is up, initialize SearchGuard by running: `docker-compose exec -T elasticsearch bin/sg_admin/init_sg.sh`

