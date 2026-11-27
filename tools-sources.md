# Android arm64 诊断工具来源（2026-11-23）

四个程序是原包的 AArch64 ELF，解释器 `/system/bin/linker64`，标记 Android API 24。未执行抓包。以下 `bin/`、`lib/`、`share/` 路径相对于 `android/usr/`，`etc/` 相对于 `android/`。

另于 2026-11-27 加入独立的 [`tree` 2.3.2（aarch64）](https://packages.termux.dev/apt/termux-main/pool/main/t/tree/tree_2.3.2_aarch64.deb)，支持 `-L` 等标准选项，不是 BusyBox applet。用同一签名密钥验证 InRelease 后逐级核对 SHA256：Packages.gz `b6b902a358b1f4cfae07767b7d14719c7f64406640e04932b9e9bcba3904d68c`，deb `77bf9ef3035a18e3b6fb5d833b7d452733e7e0cff889bd2b71e5071c58a54867`，`bin/tree` `07447dc028eb28d9f09471d28123daff9a9d46723261207df59b7973a4f6a3c0`。依赖已有的 `libandroid-support.so` 和系统 `libc.so`；原包引用的 GPL-2.0 文本取自同一索引的 `termux-licenses` 2.2，保存在 `share/licenses/diagnostic-tools/tree/copyright`。

## 启动环境与限制

- 库目录：`$ADBS_ROOT/usr/lib` 应置于 `LD_LIBRARY_PATH` 首位。实体文件按 `DT_NEEDED` 名称安装，不依赖符号链接；不覆盖 Zsh 已提供的同内容 `libandroid-support.so`、`libpcre2-8.so`。即使系统有 zlib，也保留本闭包要求的 `libz.so.1`。
- curl：设置 `CURL_CA_BUNDLE="$ADBS_ROOT/etc/tls/cert.pem"`，或显式 `--cacert`；没有禁用主机名或证书链校验。CA 是 Mozilla 派生的静态快照（118 张），不会随 Android 信任库更新。
- `dig` 内置的默认 resolv.conf 在 Termux 私有前缀。部分设备上普通 shell 无权访问，连 `dig -v` 也会在解析参数前失败，显式指定服务器不能绕过；此时 `adbs --check` 会报告该错误。
- 只装列表中的 ELF 和 CA，不带 BusyBox applet 链接、Termux 用户空间或可选插件、Kerberos 配置等。BusyBox 用 `busybox <applet>`；部分 applet 的外部程序/硬编码路径在独立环境可能不可用。DT_NEEDED 闭包不保证所有 dlopen 或可选协议功能。tcpdump 的权限仍受设备能力与 SELinux 限制。

## 索引与校验

用 HTTPS 获取 InRelease，以固定[配方版本](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/termux-keyring)中的 termux-autobuilds.gpg 经 gpgv 验签；签名指纹 `CC72CF8BA7DBFA0182877D045A897D96E57CF20C`。将压缩索引的实际 SHA256 与 InRelease 的 SHA256 段比对，再将每个 deb 与索引条目比对。滚动镜像不保证永久保留旧包。

- [termux-main](https://packages.termux.dev/apt/termux-main/dists/stable/main/binary-aarch64/Packages.gz)：`1b73f676632c11c9ba26c79323a3e371b42b8d8480e6d1699dae1c4391ae7211`
- [termux-root](https://packages.termux.dev/apt/termux-root/dists/root/stable/binary-aarch64/Packages.gz)：`0587992da3ee5bdaecd9fb07a867e6c7da03bb353dadd93c6f5a1d504ae8b087`

## 软件包与源码入口

配方包含上游版本/下载位置、补丁或内联源码。链接是与包版本对照的配方快照，不是该 deb 构建提交的签名证明。`libc++` 配方输入为 NDK r30 预编译库，并非可直接重建该库的源码包。

|包（精确版本）|deb SHA256|构建配方|
|---|---|---|
|[busybox 1.38.0-1](https://packages.termux.dev/apt/termux-main/pool/main/b/busybox/busybox_1.38.0-1_aarch64.deb)|`1bb7f1d4c00cadd0e1117b6dd7110311b8bf749ef00b486e96cfdc11c98f8fd9`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/busybox)|
|[ca-certificates 1:2026.11.05-1](https://packages.termux.dev/apt/termux-main/pool/main/c/ca-certificates/ca-certificates_1:2026.11.05-1_all.deb)|`12fc350fc5ad638338b06b04835bce897615f8c93f96d30ac396cdb39b850c6b`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/ca-certificates)|
|[curl 8.23.0](https://packages.termux.dev/apt/termux-main/pool/main/c/curl/curl_8.23.0_aarch64.deb)|`e57a9975a828eb48790bec0da950795af165aa714f6a33d266c45a4e2898aa85`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libcurl)|
|[dnsutils 9.20.31](https://packages.termux.dev/apt/termux-main/pool/main/d/dnsutils/dnsutils_9.20.31_aarch64.deb)|`c02d34f2758275b07e26a10fedc82b2bd8d68cfcdfcd092e56d213bb6451df36`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/dnsutils)|
|[json-c 0.19](https://packages.termux.dev/apt/termux-main/pool/main/j/json-c/json-c_0.19_aarch64.deb)|`894fef1e1001807e862f909cd5645dbb51bc77434779124f69178efe13690655`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/json-c)|
|[krb5 1.22.3](https://packages.termux.dev/apt/termux-main/pool/main/k/krb5/krb5_1.22.3_aarch64.deb)|`2f8b1831df2d00f821d71b44da2babada49097bc71a1ffcd25bcdbeff466564a`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/krb5)|
|[libandroid-execinfo 0.1-3](https://packages.termux.dev/apt/termux-main/pool/main/liba/libandroid-execinfo/libandroid-execinfo_0.1-3_aarch64.deb)|`725dd2c6da7fc96e860fcc928e18aa9fb0e85e0bdcaf4f8ce0f0654ca6860fc2`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libandroid-execinfo)|
|[libandroid-glob 0.6-3](https://packages.termux.dev/apt/termux-main/pool/main/liba/libandroid-glob/libandroid-glob_0.6-3_aarch64.deb)|`2276ae8adedf0db76c2f4ffc94cc4cceb2f4f5d78e021b54e2e046d1233e7826`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libandroid-glob)|
|[libandroid-selinux 14.0.0.11-1](https://packages.termux.dev/apt/termux-main/pool/main/liba/libandroid-selinux/libandroid-selinux_14.0.0.11-1_aarch64.deb)|`00afd8c34087c2864737b51fd9d104dc5e955f6ec3c0f50c0c7ef5b4a56866b9`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libandroid-selinux)|
|[libandroid-spawn 0.3](https://packages.termux.dev/apt/termux-main/pool/main/liba/libandroid-spawn/libandroid-spawn_0.3_aarch64.deb)|`7988fa788ef48ab5da9660443905a2e4099ac36221739d72f5c39acc644b4d1c`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libandroid-spawn)|
|[libandroid-support 29-1](https://packages.termux.dev/apt/termux-main/pool/main/liba/libandroid-support/libandroid-support_29-1_aarch64.deb)|`f2f145d6135ad4843ac9670153be3e3944dc1e6f1736d46d2306c28f2b86f517`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libandroid-support)|
|[libc++ 30](https://packages.termux.dev/apt/termux-main/pool/main/libc/libc++/libc++_30_aarch64.deb)|`53d0b84a7ba7459024257cb94d5b136fe13ef858567f65a8064b35950799f2ca`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libc++)|
|[libcap-ng 2:0.9.6](https://packages.termux.dev/apt/termux-main/pool/main/libc/libcap-ng/libcap-ng_2:0.9.6_aarch64.deb)|`68e8e2a95e5ac061e40717654fe2014042d88bfa2b85455713ed992eb694f89d`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libcap-ng)|
|[libcurl 8.23.0](https://packages.termux.dev/apt/termux-main/pool/main/libc/libcurl/libcurl_8.23.0_aarch64.deb)|`2011bb9709261bb3d5ecaa6672faa333be14cf48ad4af37031e3e365309557ac`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libcurl)|
|[libiconv 1.19.1](https://packages.termux.dev/apt/termux-main/pool/main/libi/libiconv/libiconv_1.19.1_aarch64.deb)|`a1c6323eff4f660e16ae6f5832356444b3269c19a4f61146355a49e7c4be5ed1`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libiconv)|
|[libnghttp2 1.71.0](https://packages.termux.dev/apt/termux-main/pool/main/libn/libnghttp2/libnghttp2_1.71.0_aarch64.deb)|`ae33e7b21e0636be8686b9b13a20e31267f047f69cb26b4befd70c9a9bae221e`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libnghttp2)|
|[libnghttp3 1.19.0](https://packages.termux.dev/apt/termux-main/pool/main/libn/libnghttp3/libnghttp3_1.19.0_aarch64.deb)|`8bb6fa31f9281cd48047ec9a571cadf153538f5b38f0203ad7a4e221344b14a6`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libnghttp3)|
|[libngtcp2 1.26.0](https://packages.termux.dev/apt/termux-main/pool/main/libn/libngtcp2/libngtcp2_1.26.0_aarch64.deb)|`8225ecde58104ef5aa234fa54a1bea5051a8a9ef2937e5ba996b3e8dda68c8eb`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libngtcp2)|
|[libpcap 1.11.0](https://packages.termux.dev/apt/termux-main/pool/main/libp/libpcap/libpcap_1.11.0_aarch64.deb)|`232193f821903eef7c54ba921f6462dfb74b58ebcee716939b81224478f898f1`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libpcap)|
|[libresolv-wrapper 1.1.8](https://packages.termux.dev/apt/termux-main/pool/main/libr/libresolv-wrapper/libresolv-wrapper_1.1.8_aarch64.deb)|`41c989a4c6f85575ac542ab5d710fead6fec4cb41941f634666a68a765c13370`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libresolv-wrapper)|
|[libssh2 1.11.1-2](https://packages.termux.dev/apt/termux-main/pool/main/libs/libssh2/libssh2_1.11.1-2_aarch64.deb)|`1add4e0a926b848814e7e2f1817ea28b123c54cabd5bbc4e5cfd65291cbad84e`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libssh2)|
|[liburcu 0.15.7](https://packages.termux.dev/apt/termux-main/pool/main/libu/liburcu/liburcu_0.15.7_aarch64.deb)|`f9eeb3441851502d5be5e159eec1582917d355c75e69e0fab7dea46b187f1aa9`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/liburcu)|
|[libuv 1.53.0](https://packages.termux.dev/apt/termux-main/pool/main/libu/libuv/libuv_1.53.0_aarch64.deb)|`781b74829af29e16f054de5b469ef1816b66d82d11baeb8beb98749d2f1de2dd`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libuv)|
|[libxml2 2.15.4-1](https://packages.termux.dev/apt/termux-main/pool/main/libx/libxml2/libxml2_2.15.4-1_aarch64.deb)|`d315861bbcf716cfb088f53cddab9fb6a96430cc66769f79774cc69c2f53bcff`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/libxml2)|
|[openssl 1:3.6.5](https://packages.termux.dev/apt/termux-main/pool/main/o/openssl/openssl_1:3.6.5_aarch64.deb)|`a2fb7856875e63ef6b90442752e05974813372c3ca86d2513a78ea43c67a0f8b`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/openssl)|
|[pcre2 10.49](https://packages.termux.dev/apt/termux-main/pool/main/p/pcre2/pcre2_10.49_aarch64.deb)|`c27995e5f52b8ecc9b8b3e662eb08e49f82a18bfd3f34343936acc7b23964724`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/pcre2)|
|[tcpdump 4.99.7](https://packages.termux.dev/apt/termux-root/pool/stable/t/tcpdump/tcpdump_4.99.7_aarch64.deb)|`56df313359373a5543f04c0f428a11fb5a23da358eeea99fbcfffd339678c875`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/root-packages/tcpdump)|
|[termux-licenses 2.2](https://packages.termux.dev/apt/termux-main/pool/main/t/termux-licenses/termux-licenses_2.2_all.deb)|`a3265cd1cf7d04754f2fb683eaf5b21918263792fd714457127900c1d6d9bcd9`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/termux-licenses)|
|[zlib 1.4](https://packages.termux.dev/apt/termux-main/pool/main/z/zlib/zlib_1.4_aarch64.deb)|`e3027565ae50bcd8ba5113c988b589754ae192c9cc3e6afbe3e4ed7c06b2598e`|[源码与补丁](https://github.com/termux/termux-packages/tree/4977ed6e93ae288cddba46d15e6ffcc4287bd4b6/packages/zlib)|

## 许可证与再发布

`share/licenses/diagnostic-tools/<包名>/` 保留原包许可或 NOTICE；通用许可证链接已用经校验的 termux-licenses 实体文本替代。curl 与 libcurl 共用版权声明。另补充以下上游材料：

- [BusyBox 1.38.0](https://busybox.net/downloads/busybox-1.38.0.tar.bz2) 的 AUTHORS、LICENSE；源码包 SHA256 已与配方核对。
- [BIND v9.20.31](https://github.com/isc-projects/bind9/tree/v9.20.31) 的 COPYING、COPYRIGHT、LICENSE、LICENSES；配方原始 ISC 下载站本次无法解析，补充声明来自同标签镜像。
- [OpenSSL 3.6.5](https://github.com/openssl/openssl/blob/openssl-3.6.5/LICENSE.txt) 及 [Android LLVM](https://android.googlesource.com/toolchain/llvm-project/+/9f872551d3c681d06fd303b36f16ed5c274735eb/) 的 libcxx、libcxxabi、libunwind 声明（LLVM 提交取自 ELF `.comment`，并非整套 NDK NOTICE 审计）。
- 未随附完整对应源码、构建工具链或源码要约。对外分发前尤其应为 BusyBox（GPLv2）及 LGPL 组件落实对应源码/再链接等要求；许可证文本、配方链接本身不等于完成这些义务。

## 运行时逐文件清单

系统提供：libc.so, libdl.so, liblog.so, libm.so。其余为实文件；以下依赖为逐项 `readelf -dW` 的直接边。

|路径|来源包|SHA256|NEEDED|
|---|---|---|---|
|`bin/busybox`|busybox|`db7f2a847ab051086c71d1c8c367e71adf59a3c39c8323ff801126ff11c84058`|libbusybox.so.1.38.0, libc.so|
|`bin/curl`|curl|`ab4dd59e71d373b000cb9b435d1ac29053ea669be9a55edbfb963ca4b2dd0141`|libcurl.so, libz.so.1, libc.so|
|`bin/dig`|dnsutils|`5389217599936eb349fe6ffdc0483e69a2ebaee560c99502c122445c8bad0e5c`|libisc-9.20.31.so, libdns-9.20.31.so, libisccfg-9.20.31.so, libc.so|
|`bin/tcpdump`|tcpdump|`0b2a6e954d689f82e987b9fe2fbba48c152d2c98449637bccc7d763a980a2cc2`|libcap-ng.so, libpcap.so.1, libcrypto.so.3, libc.so|
|`etc/tls/cert.pem`|ca-certificates|`427c064216761a1e72a8b30f0d954d08cb6e4435a82091fb865afd20c8497285`||
|`lib/libandroid-execinfo.so`|libandroid-execinfo|`778fa9eaf0a6f53282af6f24d2f93f56653c008b0f6c0041b6844dbda05aae3d`|libdl.so, libc.so|
|`lib/libandroid-glob.so`|libandroid-glob|`e47405b23e40aea9bd5aad4c3cbf518065cba8ef1c4e24c8aae7fd77e10fe850`|libc.so|
|`lib/libandroid-selinux.so`|libandroid-selinux|`d769bc3757df751e4c302cdb55062a33cda2041ba0483d953d93100cd321a810`|libpcre2-8.so, liblog.so, libc.so|
|`lib/libandroid-spawn.so`|libandroid-spawn|`a119e73710fd6dc3bb85dc58df48a9262fa5cb3318c153b9b75c1c3b23fc0e10`|libc++_shared.so, libdl.so, libc.so|
|`lib/libandroid-support.so`|libandroid-support|`739cf829511d71dafd6c67fdbb70f3f0c6048642ea2e1967790ee961fde14430`|libc.so|
|`lib/libbusybox.so.1.38.0`|busybox|`b8153ac191754afcd6dd1896f961c7ecf3965cafd727a2690f648fdd9ba57cc1`|libandroid-selinux.so, libm.so, libc.so|
|`lib/libc++_shared.so`|libc++|`05bef9d3901910c3ff8ab450b03bc8b28383d363a2290f2f7b9aed7331ea6ff7`|libc.so, libm.so, libdl.so|
|`lib/libcap-ng.so`|libcap-ng|`89ccdc85a606b35b2c36ff1162d92ecfc3fa9f9a4072b19559762475f22b8e10`|libc.so|
|`lib/libcom_err.so.3`|krb5|`473805c407585a422b1dc9c1b268d76fcf7b4d92929b716096897771d15fbbf4`|libkrb5support.so.0, libandroid-glob.so, libresolv_wrapper.so, libandroid-support.so, libc.so|
|`lib/libcrypto.so.3`|openssl|`5dddfd86746aabaca2c13eea108c8968811a4f9dcccf5889e34ebff6be920949`|libdl.so, libc.so|
|`lib/libcurl.so`|libcurl|`2cf3fbda24c995fee757cacc41b708edb905a19562e40de808549629671faca9`|libnghttp3.so, libngtcp2_crypto_ossl.so, libngtcp2.so, libnghttp2.so, libssh2.so, libssl.so.3, libcrypto.so.3, libz.so.1, libc.so|
|`lib/libdns-9.20.31.so`|dnsutils|`5a9257bc08ceb0d12d31cbab991621abf40831ea37b40c22bb5d5f1ca8e373c1`|libandroid-glob.so, libisc-9.20.31.so, libuv.so, libssl.so.3, libcrypto.so.3, libjson-c.so, libxml2.so.16, libgssapi_krb5.so.2, libkrb5.so.3, libk5crypto.so.3, libcom_err.so.3, libandroid-execinfo.so, libc.so, libm.so, liburcu-qsbr.so, liburcu-common.so, liburcu-cds.so|
|`lib/libgssapi_krb5.so.2`|krb5|`048fdf9d03ce3ee6563a98cb36f5d6e898967a041b2e0e48a8692d090874e286`|libkrb5.so.3, libk5crypto.so.3, libcom_err.so.3, libkrb5support.so.0, libandroid-glob.so, libresolv_wrapper.so, libandroid-support.so, libc.so|
|`lib/libiconv.so`|libiconv|`540df15e445f9117ce757dedf54fefd93c4db34ecf2caf06ef1cb397ac6fc940`|libc.so|
|`lib/libisc-9.20.31.so`|dnsutils|`5df64f40de40b0ef817059d1710015675e40e006ced697768b7797c71e776955`|libandroid-glob.so, libuv.so, libssl.so.3, libcrypto.so.3, libz.so.1, libjson-c.so, libnghttp2.so, libxml2.so.16, libandroid-execinfo.so, libc.so, libm.so, liburcu-qsbr.so, liburcu-common.so, liburcu-cds.so|
|`lib/libisccfg-9.20.31.so`|dnsutils|`8a09fe57d7cd64bb60ce5c8fd243a26eebe5859d0be2514f30100b36f3a65a53`|libandroid-glob.so, libdns-9.20.31.so, libisc-9.20.31.so, libns-9.20.31.so, libssl.so.3, libcrypto.so.3, libandroid-execinfo.so, libc.so, libm.so, liburcu-qsbr.so, liburcu-common.so, liburcu-cds.so|
|`lib/libjson-c.so`|json-c|`c310addbf3aabf15980350857468fac90588344c7e155037fad6d3b4cdf3b510`|libc.so|
|`lib/libk5crypto.so.3`|krb5|`825807a294e505b25f2afe54e5cbd3f60d83df84da0d5bac0c52191199441fc5`|libkrb5support.so.0, libandroid-glob.so, libresolv_wrapper.so, libandroid-support.so, libc.so|
|`lib/libkrb5.so.3`|krb5|`ae6137669fdeeff80f90caef09f304303c79fc259cb5abb4bebd2584331206bc`|libk5crypto.so.3, libcom_err.so.3, libkrb5support.so.0, libandroid-glob.so, libresolv_wrapper.so, libandroid-support.so, libdl.so, libc.so|
|`lib/libkrb5support.so.0`|krb5|`e5ab6867085b8fda9e470cbcfe12c9233f1ac14a5a4ab5d73506de47c73d7921`|libandroid-glob.so, libresolv_wrapper.so, libandroid-support.so, libdl.so, libc.so|
|`lib/libnghttp2.so`|libnghttp2|`1cc00f586a6030f1b310cef67d97675ce13892cc6664dd65ed4dd04794085b62`|libc.so|
|`lib/libnghttp3.so`|libnghttp3|`8fbf1268d67858c0d32dd356d6600a0fa1f78769448d7337a476cc7f209fb4c0`|libc.so|
|`lib/libngtcp2.so`|libngtcp2|`6f51910ff9a7a04c614edf78f5d584c40b713e6488d4bf3c840409f67e7478e4`|libc.so|
|`lib/libngtcp2_crypto_ossl.so`|libngtcp2|`2aab36576b4b41f596f44cb044d91aa0629a41f23d830773ef84a966a38bdc33`|libngtcp2.so, libssl.so.3, libcrypto.so.3, libc.so|
|`lib/libns-9.20.31.so`|dnsutils|`f2ba7aaf663318bb1cd04a9fc8471339e26e1a6686ae5ab4ba4a4d60c37201e1`|libandroid-glob.so, libdns-9.20.31.so, libisc-9.20.31.so, libuv.so, libssl.so.3, libcrypto.so.3, libandroid-execinfo.so, libc.so, libm.so, liburcu-qsbr.so, liburcu-common.so, liburcu-cds.so|
|`lib/libpcap.so.1`|libpcap|`cfade5bd78b93925a5f08faf5c43251dfd21196e06e38bcb1d45706117b3310b`|libc.so|
|`lib/libpcre2-8.so`|pcre2|`52c7ab426f4f274f630d05ef04c852153f4bb7e78ae178ce61cb17e258569bdf`|libc.so|
|`lib/libresolv_wrapper.so`|libresolv-wrapper|`685d6634543cbc7c380bd076d6877c917ef4a55569dbdca6182900ab3ee3f28d`|libdl.so, libc.so|
|`lib/libssh2.so`|libssh2|`82e42fa48c77efd4b4296d3b09e44e68f192b220714da81ef60b1edc36211bea`|libssl.so.3, libcrypto.so.3, libz.so.1, libc.so|
|`lib/libssl.so.3`|openssl|`595ce9fe0189a24ceae2eaa07721ac428a6df26794f5bfcfe4347013cbd4b9f2`|libcrypto.so.3, libc.so|
|`lib/liburcu-cds.so`|liburcu|`612fbaa29fe06c400055ed848cf3f43fea573d609eebadbd201141444f460f19`|liburcu-common.so, libc.so|
|`lib/liburcu-common.so`|liburcu|`2640ab3674627fd48287e29917ea0c7c1304ba8b877079b34e2cc746130c3029`|libc.so|
|`lib/liburcu-qsbr.so`|liburcu|`47066310bf3bdb8e78f805f582fd0f6bab02d48b55ddfe1e46dbea8012e3dd0b`|liburcu-common.so, libc.so|
|`lib/libuv.so`|libuv|`923e6f65e503a8b236c48bb01eb8d588455cc3a8c074ba63bd4f4d7f9846c263`|libandroid-spawn.so, libdl.so, libc.so|
|`lib/libxml2.so.16`|libxml2|`ed8fca535487054960e6a4edb0b4a14c5efe6256710f3b2f0bf66f59343960e6`|libm.so, libz.so.1, libiconv.so, libdl.so, libc.so|
|`lib/libz.so.1`|zlib|`df5e95e3ea1ffb8f2e0dcebfc43a6c0824b6aebec11752ad8f8764123e24f8a6`|libc.so|
