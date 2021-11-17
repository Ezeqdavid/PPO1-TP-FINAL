import wollok.game.*
import direcciones.*

object utilidadesParaJuego {
	
	method posicionArbitraria() {
		const position = game.at(0.randomUpTo(game.width()).truncate(0), 1.randomUpTo(game.height()).truncate(0))
		 if (not game.getObjectsIn(position).isEmpty()) {
		 	self.posicionArbitraria()
		 } 
		 return position
	}
	
	method posicionArbitrariaEntre(inicioAncho, finAncho, inicioAlto, finAlto) {
		const position = game.at(inicioAncho.randomUpTo(finAncho).truncate(0), inicioAlto.randomUpTo(finAlto).truncate(0))
		 if (not game.getObjectsIn(position).isEmpty()) {
		 	self.posicionArbitraria()
		 } 
		 return position
	}
	
	method posicionArbitrariaParaCofres() {
		const position = game.at(1.randomUpTo(game.width().truncate(0) - 1), 2.randomUpTo(game.height().truncate(0) - 1))
		 if (game.getObjectsIn(position).size() > 0) {
		 	self.posicionArbitrariaParaCofres()
		 } 
		 return position
	}
}

