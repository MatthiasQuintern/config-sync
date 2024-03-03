# Maintainer: Matthias Quintern <matthias dot quintern at posteo dot de>
pkgname=config-sync
pkgver=2.0
pkgrel=1
pkgdesc="easily backup and synchronize configuration files"
arch=('any')
url="https:/github.com/MatthiasQuintern/config-sync"
license=('GPL3')
depends=('rsync')
source=(config-sync.sh _config-sync.compdef.zsh config-sync.1.man config-sync.conf)
sha256sums=(aacd7f930612ac964bc744c96827451a250c6140f32caae76f6ff806843e1baa 77ca19f9270007d8689fc634ba4a0bca34f4966eba7a3f1dfcc89fa88fb4f270 ea726ce29003583c28fe63a36356e80cd3be0f84750004fa27170d637de7d43b 3b6ddad2f3037dad57fdedfe808fe26deb333011cdeb5d1b35be88d6fadb0a19)

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
