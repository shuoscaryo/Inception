PROJECT := inception
CONTAINERS := mariadb wordpress nginx
YML_PATH = ./srcs/docker-compose.yml
VOL_DIR := /home/orudek/data
VOLUMES := mariadb wordpress
VOLUME = $(addprefix $(VOL_DIR)/,$(VOLUMES))
ENV_FILE := .env

DOCKER_COMPOSE := sudo ENV_FILE=$(ENV_FILE) docker compose -f $(YML_PATH) -p $(PROJECT)

run: $(VOLUME)	
	$(DOCKER_COMPOSE) up --build --remove-orphans

dt: $(VOLUME)
	$(DOCKER_COMPOSE) up --build -d --remove-orphans

down:
	$(DOCKER_COMPOSE) down

stop:
	$(DOCKER_COMPOSE) stop 

clean:
	$(DOCKER_COMPOSE) down -v --remove-orphans --rmi all

fclean: clean
	sudo rm -rf $(VOL_DIR)

re: fclean run

$(VOLUME):
	mkdir -p $(VOLUME) 2>/dev/null

exec-%:
	$(DOCKER_COMPOSE) exec $* sh

$(foreach CONTAINER,$(CONTAINERS),$(eval $(CONTAINER): exec-$(CONTAINER)))

.PHONY: run dt down stop clean fclean re exec-% $(foreach CONTAINER,$(CONTAINERS),$(CONTAINER))
