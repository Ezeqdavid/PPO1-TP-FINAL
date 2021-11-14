import wollok.game.*
import personajes.*
import utilidades.*
import personajes.*
import nivel1.*
/* 
class Bloque {
	var property position
	const property image = "market.png" 	
	
	// agregar comportamiento	
}
*/

class PowerUp {
	const property position 
	//const cantEner = 30
	//const cantSalud = 30 para que hacer una constatnte que no va a cambiar y luego hacer una cuenta, cuando podes sumarle el numero directamente.
	method reaccionar(personaje) {
		game.removeVisual(self)
	}
	method esMovible() {return true}
}

class PocionMana inherits PowerUp{
    const property image = "flask_big_blue.png"
	override method reaccionar(personaje) {super(personaje) personaje.energia(personaje.energia() + 6)}
}

class VesselMana inherits PowerUp {
	const property image = "flask_blue.png"
	override method reaccionar(personaje) {super(personaje) personaje.energia(personaje.energia() + 2.5)}
}

class PocionSalud inherits PowerUp {
	const property image = "flask_big_red.png"
	override method reaccionar(personaje) {super(personaje) personaje.salud(personaje.salud() + 15)}
}

class VesselSalud inherits PowerUp {
	const property image = "flask_red.png"
	override method reaccionar(personaje) {super(personaje) personaje.salud(personaje.salud() + 5)}
}

class Monedas inherits PowerUp {
	const property image = "coin_anim_f0.png"
	override method reaccionar(personaje) {super(personaje) personaje.dinero(personaje.dinero() + 5)}
}

class Cofre {
	const property image = "chest_empty_open_anim_f0.png"
	var property position = game.at(2, 3)
	
	method esMovible() {return true}

	method reaccionar(personaje) {
		const newPosition = personaje.direccion().siguiente(position)
		if (newPosition.y() != game.height() and 
			newPosition.x() != game.width() and
			newPosition.x() != -1 and 
			newPosition.y() != -1) {
			
			position = newPosition	
		}
	}

}

class FragmentoEspada {
	const property image = "Broken_golden_sword.png"
	const property position 
	method reaccionar(personaje) {
		personaje.recogerFragmento(self)
		game.removeVisual(self)
	}
	method esMovible() {return true}
}

class CeldaSorpresa {
	const property image = "celdaSorpresa.png"
	const property position
	method reaccionar(personaje) {game.removeVisual(self)}
	method esMovible() {return true} 
}

class CeldaQuitaEnergia inherits CeldaSorpresa {
	override method reaccionar(personaje) {
		super(personaje)
		personaje.energia(personaje.energia() - 15)
	}
}

class CeldaAgregaEnergia inherits CeldaSorpresa {
	override method reaccionar(personaje) {
		super(personaje)
		personaje.energia(personaje.energia() + 30)
	}
}

class CeldaTeletransportadora inherits CeldaSorpresa {
	override method reaccionar(personaje) {
		super(personaje)
		personaje.position(utilidadesParaJuego.posicionArbitraria())
	}
}

class Indicador {
	const property position
	method reaccionar(personaje)
	method visualizar(personaje)
}

class IndicadorSalud inherits Indicador {
	var property image = "ui_heart_full.png"
	override method visualizar(personaje) {
		if (personaje.salud() < 15) {
			self.image("ui_heart_half.png") 
		} else {
			self.image("ui_heart_full.png")
		}
	}
}

class IndicadorEnergia inherits Indicador {
	var property image = "ui_heart_full.png"
	override method visualizar(personaje) {
		if (personaje.energia() < 15) {
			self.image("ui_heart_half.png") 
		} else {
			self.image("ui_heart_full.png")
		}
	}
}

class Forja {
	const property image = "wall_fountain_basin_red_anim_f0.png"
	const property position
	var property fragmentos = []
		
	method esMovible() {return false}	
	method reaccionar(personaje) {
		fragmentos.addAll(personaje.fragmentos())
		if (fragmentos.size() == 3) {
			nivelBloques.terminar()
		} else {
			game.say(self, "Animo, aun faltan mas fragmentos.")
		}
	}
}

class Escalera {
	const property image = "Escalera.png"
	const property position 
	var property cofresPisoInferior = []
	
	method esMovible() {return false}
	
	method reaccionar(cofre) {
		cofresPisoInferior.add(cofre)
		game.removeVisual(cofre)
	}
}
