PLATFORM_IS_JELLYBEAN := 1
ifneq (, $(findstring 4.2., $(PLATFORM_VERSION)))
PLATFORM_IS_JELLYBEAN_MR1 := 1
endif
ifeq ($(PLATFORM_VERSION),4.3)
PLATFORM_IS_JELLYBEAN_MR1 := 1
PLATFORM_IS_JELLYBEAN_MR2 := 1
endif
ifeq ($(PLATFORM_VERSION),4.4)
PLATFORM_IS_JELLYBEAN_MR1 := 1
PLATFORM_IS_JELLYBEAN_MR2 := 1
PLATFORM_IS_KITKAT := 1
endif

ifeq ($(PLATFORM_VERSION),4.4.2)
PLATFORM_IS_JELLYBEAN_MR1 := 1
PLATFORM_IS_JELLYBEAN_MR2 := 1
PLATFORM_IS_KITKAT := 1
endif

ifneq (, $(findstring 3., $(PLATFORM_VERSION)))
  ifeq ($(BUILD_GOOGLETV),true)
     PLATFORM_IS_GTV_HC := 1
     PLATFORM_IS_JELLYBEAN :=
  endif
endif

$(warn ALERT platform is jellybean mr1 = $(PLATFORM_IS_JELLYBEAN_MR1))
