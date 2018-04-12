#
# Copyright (C) 2017 Jian Chang <aa65535@live.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=simple-obfs
PKG_VERSION:=0.0.5
PKG_RELEASE:=3

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/shadowsocks/simple-obfs.git
PKG_SOURCE_VERSION:=3763198a49740eba90f945b097572e06e02e3d63
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Jian Chang <aa65535@live.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/simple-obfs/Default
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Simple-obfs
	URL:=https://github.com/shadowsocks/simple-obfs
endef

define Package/simple-obfs
	$(call Package/simple-obfs/Default)
	VARIANT:=shared
	DEPENDS:=+libev +libpthread
endef

Package/simple-obfs-server = $(Package/simple-obfs)

define Package/simple-obfs-static
	$(call Package/simple-obfs/Default)
	VARIANT:=static
	DEPENDS:=+libpthread
	PKG_BUILD_DEPENDS:=+libev
endef

Package/simple-obfs-server-static = $(Package/simple-obfs-static)

define Package/simple-obfs/description
Simple-obfs is a simple obfusacting tool, designed as plugin server of shadowsocks.
endef

Package/simple-obfs-server/description = $(Package/simple-obfs/description)

Package/simple-obfs-static/description = $(Package/simple-obfs/description)
Package/simple-obfs-server-static/description = $(Package/simple-obfs/description)

CONFIGURE_ARGS += \
				--disable-ssp \
				--disable-documentation \
				--disable-assert

ifeq ($(BUILD_VARIANT),static)
	CONFIGURE_ARGS += \
				--with-ev="$(STAGING_DIR)/usr" \
				LDFLAGS="-Wl,-static -static -static-libgcc"
endif

define Package/simple-obfs/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/obfs-local $(1)/usr/bin
endef

Package/simple-obfs-static/install = $(Package/simple-obfs/install)

define Package/simple-obfs-server/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/obfs-server $(1)/usr/bin
endef

Package/simple-obfs-server-static/install = $(Package/simple-obfs-server/install)

$(eval $(call BuildPackage,simple-obfs))
$(eval $(call BuildPackage,simple-obfs-server))

$(eval $(call BuildPackage,simple-obfs-static))
$(eval $(call BuildPackage,simple-obfs-server-static))
