import wollok.game.*
import direcciones.*

object utilidadesParaJuego {

	method posicionArbitraria() {
		return game.at(0.randomUpTo(game.width()).truncate(0), 1.randomUpTo(game.height()).truncate(0))
	}
	
	method posicionArbitrariaParaCofres() {
		return game.at(1.randomUpTo(game.width().truncate(0) - 1), 1.randomUpTo(game.height().truncate(0) - 1))
	}
}

