import wollok.game.*
import direcciones.*

object utilidadesParaJuego {

	method posicionArbitraria() {
		return game.at(0.randomUpTo(game.width()).truncate(0), 0.randomUpTo(game.height()).truncate(0))
	}

	method numeroArbitrario() {
		return 0.randomUpTo(30)
	}

}

object caja {

	const property image = "caja.png"
	var property position = game.at(2, 3)

	method mover(direccion) {
		position = direccion.siguiente(position)
	}

}

