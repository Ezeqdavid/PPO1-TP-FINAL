import wollok.game.*
import personajes.*
import utilidades.*
import personajes.*
import nivel3.*

class Enemigo {
	var property position = utilidadesParaJuego.posicionArbitraria()
	var property salud
	var property image

	method movimiento(personaje) {
		game.schedule(5000, { => self.acercarseA(personaje)})
	}

	method acercarseA(personaje) {
		const otroPosicion = personaje.position()
		var newX = position.x() + if (otroPosicion.x() > position.x()) 1 else -1
		var newY = position.y() + if (otroPosicion.y() > position.y()) 1 else -1
		newX = newX.max(0).min(game.width() - 1)
		newY = newY.max(0).min(game.height() - 1)
		position = game.at(newX, newY)
	}


method reaccionar(personaje)
	
method daniar(personaje)

}

class Diablito inherits Enemigo {
	
	method initialize() {
		self.salud(20)
	}
	
	override method reaccionar(personaje) {
		personaje.recibirDanio()
	}

}

class Goblin inherits Enemigo {
	
	method initialize() {
		self.salud(40)
	}
	override method reaccionar(personaje) {
		personaje.recibirDanio()
	}
}

class Orco inherits Enemigo {
	method initialize() {
		self.salud(60)
		self.image("ogre_idle_anim_f0.png")
	}
	override method reaccionar(personaje) {
		personaje.recibirDanio()
	}

}

