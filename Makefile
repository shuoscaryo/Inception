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
	sudo docker compose -f $(YML_PATH) -p $(PROJECT) down

stop:
	sudo docker compose -f $(YML_PATH) -p $(PROJECT) stop 

clean:
	sudo docker compose -f $(YML_PATH) -p $(PROJECT) down -v --remove-orphans --rmi all

fclean: clean
	sudo rm -rf $(VOL_DIR)

re: fclean run

$(VOLUME):
	mkdir -p $(VOLUME) 2>/dev/null

exec-%:
	sudo docker compose -f $(YML_PATH) -p $(PROJECT) exec $* sh

$(foreach CONTAINER,$(CONTAINERS),$(eval $(CONTAINER): exec-$(CONTAINER)))

.PHONY: run dt down stop clean fclean re exec-% $(foreach CONTAINER,$(CONTAINERS),$(CONTAINER))