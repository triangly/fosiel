TARGET_BITS ?= 64
TARGET_NAME ?= fosiel

BUILD_DIR   ?= build/x$(TARGET_BITS)
SOURCE_DIR  ?= src

SRCS := $(shell find $(SOURCE_DIR) -name *.c)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INCLUDE_DIRS ?=
INCLUDE_FLAG :=  $(addprefix -I,$(shell find $(SOURCE_DIR) -type d)) $(addprefix -I,$(INCLUDE_DIRS))

LANGSTD     ?= c99
OPTIMIZELVL ?= 2

CFLAGS ?= $(INCLUDE_FLAG) -m$(TARGET_BITS) -std=$(LANGSTD) -O$(OPTIMIZELVL)

MKDIR ?= mkdir
ECHO  ?= echo
RM    ?= rm
CC     = clang

$(BUILD_DIR)/$(TARGET_NAME): $(OBJS)
	@$(MKDIR) -p $(dir $@)
	@$(ECHO) "Linking final executale > $@"
	@$(CC) $(CFLAGS) $(OBJS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.c.o: %.c
	@$(MKDIR) -p $(dir $@)
	@$(ECHO) "Compiling $<"
	@$(CC) $(CFLAGS) -c $< -o $@

.PHONY: run clean

run: $(BUILD_DIR)/$(TARGET_NAME)
	@$(ECHO) "Executing $(BUILD_DIR)/$(TARGET_NAME)"
	@$(ECHO) "----------------------------------------------------------"
	@$(BUILD_DIR)/$(TARGET_NAME)

clean:
	@$(ECHO) "Performing build clean..."
	@$(RM) -r $(BUILD_DIR)
