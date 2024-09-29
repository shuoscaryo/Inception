PROJECT := inception
CONTAINERS := mariadb wordpress nginx
YML_PATH = ./srcs/docker-compose.yml
VOL_DIR := /home/oscar/data
VOLUMES := mariadb wordpress
VOLUME = $(addprefix $(VOL_DIR)/,$(VOLUMES))

run: $(VOLUME)
	sudo docker compose -f $(YML_PATH) -p $(PROJECT) up --build --remove-orphans

dt: $(VOLUME)
	sudo docker compose -f $(YML_PATH) -p $(PROJECT) up --build -d --remove-orphans

down:
	sudo docker compose -f $(YML_PATH) down 

clean:
	sudo rm -rf $(VOL_DIR)
	docker rmi mariadb wordpress nginx || true
	sudo docker compose -f $(YML_PATH) down -v || true
	sudo docker image prune -f

re: clean run

$(VOLUME):
	mkdir -p $(VOLUME) 2>/dev/null

exec-%:
	sudo docker compose -f $(YML_PATH) exec $* sh

$(foreach CONTAINER,$(CONTAINERS),$(eval $(CONTAINER): exec-$(CONTAINER)))
