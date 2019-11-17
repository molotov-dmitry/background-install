TARGET			= 
INSTALL_DIR		= $(PREFIX)/usr/share/backgrounds

FILES			= $(wildcard $(TARGET)/*)
INSTALL_FILES	= $(addprefix $(INSTALL_DIR)/,$(FILES))

DM_LIST			= gnome cinnamon mate
DM_PATH_LIST	= $(addsuffix -background-properties/$(TARGET).xml,$(addprefix $(PREFIX)/usr/share/,$(DM_LIST)))

.PHONY: all install uninstall

all:

install: $(INSTALL_DIR)/$(TARGET) $(INSTALL_FILES) $(INSTALL_DIR)/$(TARGET)/$(TARGET).xml $(DM_PATH_LIST)

uninstall:
	rm -rf $(INSTALL_DIR)/$(TARGET)
	
### Automatic wallpaper cahnge =================================================

$(INSTALL_DIR)/$(TARGET)/$(TARGET).xml: $(INSTALL_DIR)/$(TARGET) $(INSTALL_FILES)
	bash gen-transition.sh $(INSTALL_DIR)/$(TARGET) "$(PREFIX)" '/' > "$(INSTALL_DIR)/$(TARGET)/$(TARGET).xml"

### Files ======================================================================

$(INSTALL_DIR)/$(TARGET):
	mkdir -p $@

$(INSTALL_DIR)/$(TARGET)/%: $(TARGET)/%
	cp -f $^ $@

### Background description =====================================================

$(PREFIX)/usr/share/%-background-properties:
	mkdir -p $@
	
$(PREFIX)/usr/share/%-background-properties/$(TARGET).xml: $(PREFIX)/usr/share/%-background-properties $(INSTALL_FILES) $(INSTALL_DIR)/$(TARGET)/$(TARGET).xml 
	bash gen-description.sh "$*" $(INSTALL_DIR)/$(TARGET) "$(PREFIX)" '/' > $@
