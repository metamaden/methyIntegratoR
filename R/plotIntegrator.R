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
