import wollok.game.*
import personajes.*
import utilidades.*
import personajes.*
/* 
class Bloque {
	var property position
	const property image = "market.png" 	
	
	// agregar comportamiento	
}
*/

class PowerUp {
	const property image 
	const property position 
	//const cantEner = 30
	//const cantSalud = 30 para que hacer una constatnte que no va a cambiar y luego hacer una cuenta, cuando podes sumarle el numero directamente.
	method reaccionar(personaje)
}

class PocionMana inherits PowerUp{
    //const image = "flask_big_blue.png"
	override method reaccionar(personaje) {personaje.energia(personaje.energia() + 6)}
}

class VesselMana inherits PowerUp {
	//const image = "flask_blue.png"
	override method reaccionar(personaje) {personaje.energia(personaje.energia() + 2.5)}
}

class PocionSalud inherits PowerUp {
	//const image = "flask_big_red.png"
	override method reaccionar(personaje) {personaje.salud(personaje.salud() + 15)}
}

class VesselSalud inherits PowerUp {
	//const image = "flask_red.png"
	override method reaccionar(personaje) {personaje.salud(personaje.salud() + 5)}
}

class Monedas inherits PowerUp {
	//const image = "coin_anim_f0.png"
	override method reaccionar(personaje) {personaje.dinero(personaje.dinero() + 5)}
}

class Cofre {

	const property image = "chest_empty_open_anim_f0.png"
	var property position = game.at(2, 3)

	method reaccionar(personaje) {
		position = personaje.direccion().siguiente(position)
	}

}




class CeldaSorpresa {
	
}
