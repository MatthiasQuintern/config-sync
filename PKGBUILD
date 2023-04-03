# Maintainer: Matthias Quintern <matthiasqui@protonmail.com>
pkgname=config-sync
pkgver=1.0
pkgrel=5
pkgdesc="easily backup and deploy configuration files"
arch=('any')
url="https:/github.com/MatthiasQuintern/config-sync"
license=('GPL3')
depends=('rsync')
source=(config-sync.sh _config-sync.compdef.zsh config-sync.1.man config-sync.conf)
md5sums=(d31c3a04d201e904c8499df3223900c7 ca58dacf1b7e04a778ac43f007ca34de fdaefe9cffa01195cfded7eba9f061c2 cfad8c606738bc9161f0f1d19d71e3b8  )

package() {
	mkdir -p "${pkgdir}/usr/bin"
	cp "${srcdir}/config-sync.sh" "${pkgdir}/usr/bin/config-sync"
	chmod +x "${pkgdir}/usr/bin/config-sync"

	mkdir -p "${pkgdir}/usr/share/man/man1/"
	cp "${srcdir}/config-sync.1.man" "${pkgdir}/usr/share/man/man1/config-sync.1"

	mkdir -p "${pkgdir}/usr/share/config-sync"
	cp "${srcdir}/config-sync.conf" "${pkgdir}/usr/share/config-sync/config-sync.conf"
	chmod +xr "${pkgdir}/usr/share/config-sync/config-sync.conf"

	# if has zsh
	if [[ -f /bin/zsh ]]; then
		mkdir -p "${pkgdir}/usr/share/zsh/site-functions"
		cp "${srcdir}/_config-sync.compdef.zsh" "${pkgdir}/usr/share/zsh/site-functions/_config-sync"
		chmod +x "${pkgdir}/usr/share/zsh/site-functions/_config-sync"
	fi
}
