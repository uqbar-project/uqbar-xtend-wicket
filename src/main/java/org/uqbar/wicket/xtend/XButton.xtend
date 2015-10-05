package org.uqbar.wicket.xtend

import org.apache.wicket.markup.html.form.Button
import org.eclipse.xtext.xbase.lib.Procedures.Procedure0
import org.uqbar.commons.model.UserException

/**
 * xtend friendly wicket button.
 * Allows you to use procedure's as onclick listeners.
 */
class XButton extends Button {
	private ()=>void procedure
	
	new(String id) {
		super(id)
	}
	
	override onSubmit() {
		try {
			procedure.apply()
		}
		catch(UserException e) {
			error(e.message)
		}
	}
	
	def setOnClick(Procedure0 procedure) {
		this.procedure = procedure
		this
	}
	
}