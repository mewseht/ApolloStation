/obj/item/device/uplink/hidden/Topic(href, href_list)
	var/mob/user = usr
	if(!user)	return

	switch(href_list["tgroup"])
		if("close")
			toggle()
			menu.close()

		if("switch_menu")
			if(href_list["task"] == "contract_menu")	contract_menu(user)
			if(href_list["task"] == "buy_menu")	buy_menu(user)
			//if("info_menu")	info_menu(user)

		if("contracts")
			contract_topic(href, href_list, user)

		if("buy")
			buy_topic(href, href_list, user)

		/*
		if("info")
			info_topic(href, href_list, user)
		*/

	return 1