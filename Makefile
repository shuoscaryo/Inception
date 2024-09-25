CONTAINERS := mariadb wordpress nginx

YML_PATH = ./srcs/docker-compose.yml

VOL_DIR := /home/orudek/data

VOLUMES := mariadb wordpress

VOLUME = $(addprefix $(VOL_DIR)/,$(VOLUMES))

RM = rm -rf 

run: $(VOLUME)
	sudo docker compose -f $(YML_PATH) up --build --remove-orphans

dt: $(VOLUME)
	sudo docker compose -f $(YML_PATH) up --build -d --remove-orphans

down:
	sudo docker compose -f $(YML_PATH) down 

re:
	$(RM) $(VOL_DIR)
	make 

$(VOLUME):
	mkdir -p $(VOLUME) 2>/dev/null

exec-%:
	sudo docker compose -f $(YML_PATH) exec $* sh

$(foreach CONTAINER,$(CONTAINERS),$(eval $(CONTAINER): exec-$(CONTAINER)))
