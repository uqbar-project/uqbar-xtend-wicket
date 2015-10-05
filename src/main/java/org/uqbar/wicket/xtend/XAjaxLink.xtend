package org.uqbar.wicket.xtend

import org.apache.wicket.ajax.AjaxRequestTarget
import org.apache.wicket.ajax.markup.html.AjaxLink
import org.apache.wicket.model.IModel
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1

/**
 * Implementacion de AjaxLink que delega en un bloque de xtend
 */
class XAjaxLink<T> extends AjaxLink<T> {
	Procedure1<AjaxRequestTarget> procedure
	
	new(String id) {
		super(id)
	}
	
	new(String id, IModel model) {
		super(id, model)
	}
	
	override onClick(AjaxRequestTarget target) {
		procedure.apply(target)
	}
	
	def void setOnClick(Procedure1<AjaxRequestTarget> procedure) {
		this.procedure = procedure
	}
	
}