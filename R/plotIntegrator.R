plotIntegrator <- function(expr.obj,
                           methyl.obj,
                           subtypes.obj,
                           plot.title,
                           limits.x=c(-10,10),
                           limits.y=c(0,1),
                           geom.hline=0,
                           geom.vline=0,
                           colors.subtypes.scale=c("black"),
                           colors.subtypes.fill=c("black"),
                           legend.pos="none",
                           show.ellipses=TRUE){
  
  # notes: expr, methyl, and subtypes objects all ordered identically (same patients/sample order)
  # colors.subtyles.scale/fill corresponds to colors of unique subtype levels (from: levels(as.factor()))
  # legend.pos defaults to none/no legend displayed
  # plot.title can be gene name
  # genom.hline/vline correspond to intercepts of axis lines to be drawn
  # limits.x/y are the upper and lower bounds of x and y axes, as a vector
  
  
  require(ggplot2)
  
  dfi <- data.frame(expr=expr.obj,
                    methy=methyl.obj,
                    subtype=subtypes.obj)
  
  if(show.ellipses){
    ggi <- ggplot(dfi,aes(expr,methy,color=subtype))+
      geom_point()+
      stat_ellipse(geom="polygon",alpha=0.2,aes(fill=dfi$subtype))+
      labs(x = "",y = "")+
      ggtitle(plot.title)+
      theme(text=element_text(size=16, family="Arial"))+ 
      scale_color_manual(values=colors.subtypes.scale)+
      scale_fill_manual(values=colors.subtypes.fill)+
      scale_y_continuous(limits = limits.y)+
      scale_x_continuous(limits = limits.x) +
      theme(legend.position=legend.pos)+
      geom_hline(yintercept = geom.hline)+
      geom_vline(xintercept= geom.vline)
    
  } else{
    ggi <- ggplot(dfi,aes(expr,methy,color=subtype))+
      geom_point()+labs(x = "",y = "")+
      ggtitle(plot.title)+
      theme(text=element_text(size=16, family="Arial"))+ 
      scale_color_manual(values=colors.subtypes.scale)+
      scale_fill_manual(values=colors.subtypes.fill)+
      scale_y_continuous(limits = limits.y)+
      scale_x_continuous(limits = limits.x) +
      theme(legend.position=legend.pos)+
      geom_hline(yintercept = geom.hline)+
      geom_vline(xintercept= geom.vline)
    
  }
  
  
  return(ggi)
  
  
}


# example
# plotIntegrator(expr.obj=c(glist[[goi]]$expr.dat$hm.expr,
 #                                            glist[[goi]]$expr.dat$im.expr,
 #                                            glist[[goi]]$expr.dat$lm.expr,
 #                                            glist[[goi]]$expr.dat$mm.expr,
 #                                            glist[[goi]]$expr.dat$normal.expr),
 #                                 methyl.obj=c(glist[[goi]]$pmethyl.dat$hm.pmethyl,
 #                                              glist[[goi]]$pmethyl.dat$im.pmethyl,
 #                                              glist[[goi]]$pmethyl.dat$lm.pmethyl,
 #                                              glist[[goi]]$pmethyl.dat$mm.pmethyl,
 #                                              glist[[goi]]$pmethyl.dat$normal.pmethyl),
 #                                 subtypes.obj=c(rep("HM",length(glist[[goi]]$pmethyl.dat$hm.pmethyl)),
 #                                                rep("IM",length(glist[[goi]]$pmethyl.dat$im.pmethyl)),
 #                                                rep("LM",length(glist[[goi]]$pmethyl.dat$lm.pmethyl)),
 #                                                rep("MM",length(glist[[goi]]$pmethyl.dat$mm.pmethyl)),
 #                                                rep("normal",length(glist[[goi]]$pmethyl.dat$normal.pmethyl))),
 #                                 plot.title=goi,
 #                                 colors.subtypes.scale=c("gold3", "coral2", "gray60","dodgerblue","purple"),
 #                                 colors.subtypes.fill=c("yellow","coral","gray60","lightblue","purple"),
 #                                 legend.pos="right",
 #                                 limits.x=c(-20,10),
 #                                 limits.y=c(-1,2))
