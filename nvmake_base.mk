ifneq ($(filter-out SHARED_LIBRARIES,$(LOCAL_MODULE_CLASS)),)
$(error The integration layer for the nvmake build system supports only shared libraries)
endif

include $(NVIDIA_NVMAKE_CLEAR)
include $(NVIDIA_BASE)
# TODO Enable coverage build

# Set to 1 to do nvmake builds in the unix-build chroot
NV_USE_UNIX_BUILD ?= 0

NVIDIA_NVMAKE_BUILD_TYPE := $(TARGET_BUILD_TYPE)
ifdef DEBUG_MODULE_$(strip $(LOCAL_MODULE))
  NVIDIA_NVMAKE_BUILD_TYPE := debug
endif

NVIDIA_NVMAKE_MODULE_NAME := $(LOCAL_MODULE)

ifeq ($(LOCAL_NVIDIA_NVMAKE_TREE),drv)
  NVIDIA_NVMAKE_TOP := $(NV_GPUDRV_SOURCE)
else
  NVIDIA_NVMAKE_TOP := $(TEGRA_TOP)/gpu/$(LOCAL_NVIDIA_NVMAKE_TREE)
endif

NVIDIA_NVMAKE_UNIX_BUILD_COMMAND := \
  unix-build \
  --no-devrel \
  --extra $(ANDROID_BUILD_TOP) \
  --extra $(P4ROOT)/sw/tools \
  --tools $(P4ROOT)/sw/tools \
  --source $(NVIDIA_NVMAKE_TOP) \
  --extra-with-bind-point $(P4ROOT)/sw/mobile/tools/linux/android/nvmake/unix-build64/lib /lib \
  --extra-with-bind-point $(P4ROOT)/sw/mobile/tools/linux/android/nvmake/unix-build64/lib32 /lib32 \
  --extra-with-bind-point $(P4ROOT)/sw/mobile/tools/linux/android/nvmake/unix-build64/lib64 /lib64 \
  --extra $(P4ROOT)/sw/mobile/tools/linux/android/nvmake

NVIDIA_NVMAKE_MODULE_PRIVATE_PATH := $(LOCAL_NVIDIA_NVMAKE_OVERRIDE_MODULE_PRIVATE_PATH)

ifneq ($(strip $(SHOW_COMMANDS)),)
  NVIDIA_NVMAKE_VERBOSE := NV_VERBOSE=1
else
  NVIDIA_NVMAKE_VERBOSE := -s
endif

# extra definitions to pass to nvmake
NVIDIA_NVMAKE_EXTRADEFS :=
ifeq ($(NVUB_UNIFIED_BRANCHING_ENABLED),1)
  NVIDIA_NVMAKE_EXTRADEFS += NVUB_UNIFIED_BRANCHING_ENABLED=$(NVUB_UNIFIED_BRANCHING_ENABLED)
  ifdef NVUB_SUPPORTS_T132
    NVIDIA_NVMAKE_EXTRADEFS += NVUB_SUPPORTS_T132=$(NVUB_SUPPORTS_T132)
  endif
endif

# We always link nvmake components against these few libraries.
# LOCAL_SHARED_LIBRARIES will enforce the install requirement, but
# LOCAL_ADDITIONAL_DEPENDENCIES will enforce that they are built before nvmake runs
LOCAL_SHARED_LIBRARIES += libc libdl libm libstdc++ libz
# Ensure libgcov_null.so is built if needed.
ifeq ($(NVIDIA_NVMAKE_BUILD_TYPE),debug)
  ifneq ($(NVIDIA_COVERAGE_ENABLED),)
    ifneq ($(LOCAL_NVIDIA_NO_COVERAGE),true)
      ifeq ($(LOCAL_NVIDIA_NULL_COVERAGE),true)
        LOCAL_SHARED_LIBRARIES += libgcov_null
      endif
    endif
  endif
endif
