import wollok.game.*
import personajes.*
import utilidades.*
import personajes.*

class Enemigo {

	var property position = utilidadesParaJuego.posicionArbitraria()
	const property image

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

	method daniar(personaje)

}

class Diablito inherits Enemigo {

	override method daniar(personaje) {
		personaje.recibirDanio(self)
	}

}

class Goblin inherits Enemigo {

	override method daniar(personaje) {
		personaje.recibirDanio(self)
	}

}

class Orco inherits Enemigo {

	override method daniar(personaje) {
		personaje.recibirDanio(self)
	}

	override method acercarseA(personaje) {
		const otroPosicion = personaje.position()
		var newX = position.x() + if (otroPosicion.x() > position.x()) 2 else -2
		var newY = position.y() + if (otroPosicion.y() > position.y()) 2 else -2
		newX = newX.max(0).min(game.width() - 1)
		newY = newY.max(0).min(game.height() - 1)
		position = game.at(newX, newY)
	}

}

