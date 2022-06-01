#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

echo '修改主机名'
sed -i "s/hostname='OpenWrt'/hostname='Phicomm-K3'/g" package/base-files/files/bin/config_generate
cat package/base-files/files/bin/config_generate |grep hostname=
echo '=========Alert hostname OK!========='

echo '修改NTP服务器地址'
sed -i "s/'0.openwrt.pool.ntp.org'/'ntp.aliyun.com'/g" package/base-files/files/bin/config_generate
sed -i "s/'1.openwrt.pool.ntp.org'/'time1.cloud.tencent.com'/g" package/base-files/files/bin/config_generate
sed -i "s/'2.openwrt.pool.ntp.org'/'time.ustc.edu.cn'/g" package/base-files/files/bin/config_generate
sed -i "s/'3.openwrt.pool.ntp.org'/'cn.pool.ntp.org'/g" package/base-files/files/bin/config_generate
cat package/base-files/files/bin/config_generate |grep system.ntp.server=
echo '=========Alert NTP server address OK!========='

# 修复核心及添加温度显示
sed -i 's|pcdata(boardinfo.system or "?")|luci.sys.exec("uname -m") or "?"|g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

# Add luci-app-dockerman
rm -rf ../lean/luci-app-docker
git clone --depth=1 https://github.com/lisaac/luci-app-dockerman
git clone --depth=1 https://github.com/lisaac/luci-lib-docker

# Add ServerChan
git clone --depth=1 https://github.com/tty228/luci-app-serverchan

# Add luci-app-diskman
git clone --depth=1 https://github.com/SuLingGG/luci-app-diskman
mkdir parted
cp luci-app-diskman/Parted.Makefile parted/Makefile

# Add OpenAppFilter
git clone --depth 1 -b oaf-3.0.1 https://github.com/destan19/OpenAppFilter.git
