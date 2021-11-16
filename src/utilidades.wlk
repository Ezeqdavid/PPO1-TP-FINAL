import wollok.game.*
import direcciones.*

object utilidadesParaJuego {
	
	method posicionArbitraria() {
		const position = game.at(0.randomUpTo(game.width()).truncate(0), 1.randomUpTo(game.height()).truncate(0))
		 if (game.getObjectsIn(position).any{o => o.hayAlgo()}) {
		 	self.posicionArbitraria()
		 } 
		 return position
	}
	
	method posicionArbitrariaParaCofres() {
		const position = game.at(1.randomUpTo(game.width().truncate(0) - 1), 2.randomUpTo(game.height().truncate(0) - 1))
		 if (game.getObjectsIn(position).any{e => e.hayAlgo()}) {
		 	self.posicionArbitraria()
		 } 
		 return position
	}
}

