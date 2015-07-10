#include "mex.h"
#include <math.h>


void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
  /**** Input and output parameters ****/
  int ordre, nbcontact;
  double lambda, mu;
  double *activ;                          /* activity of each muscles */
  double *ncontact;
  double *IA, *IB, *IC, *ID, *IE;         /* index field */
  double *XY;                             /* mesh */
  double *AA;                             /* stiffness matrix */
 
  /**** local variables *****/
  double H[4][4],G[4][4];                 /* Gauss : HH:  weights GG: points */
  int IAfix[64],IDfix[64];
  double A[64],B[64],C[64],D[64],E[64];
  int IAi[64], IBi[64], ICi[64], IDi[64], IEi[64];
  int saut,jj,pfix,i,j,k;
  double xtmp[4],ytmp[4];            
  double KK[64];                        /* Element stiffness matrix */
  double lambda2,mu2,tmpdet,detJ,stotmp1,stotmp2,stotmp3,stotmp4;
  double s,r,dpsidr[4],dpsids[4],dpsi[9];
  int debut,indice[64];

  /****** Input parameters ******/
  ordre = mxGetScalar(prhs[0]);
  lambda = mxGetScalar(prhs[1]);
  mu = mxGetScalar(prhs[2]);
  IA = mxGetPr(prhs[3]);
  IB = mxGetPr(prhs[4]);
  IC = mxGetPr(prhs[5]);
  ID = mxGetPr(prhs[6]);
  IE = mxGetPr(prhs[7]);
  activ = mxGetPr(prhs[8]);
  XY = mxGetPr(prhs[9]);  
  ncontact = mxGetPr(prhs[10]);
  nbcontact = mxGetN(prhs[10]);

  /* new values that are not variable but constant */
  int fact = 2;
  int NN = 13;
  int MM = 17;

  /****** Output parameters ******/
  plhs[0] = mxCreateDoubleMatrix(1,4*NN*NN*MM*MM,mxREAL);
  AA = mxGetPr(plhs[0]);

  /************************************/
  /*        The C subroutine         */
  /**********************************/

  /*** Convert real into integer ***/
  for (i=0; i<64; i++)
    {
      IAi[i] = (int)IA[i];
      IBi[i] = (int)IB[i];
      ICi[i] = (int)IC[i];
      IDi[i] = (int)ID[i];
      IEi[i] = (int)IE[i];
    }

  /*** initialisation ***/

  H[1][1] = 2.;
  H[2][1] = 1.;
  H[2][2] = 1.;
  H[3][1] = 0.555556;
  H[3][2] = 0.888889;
  H[3][3] = 0.555556;

  G[1][1] = 0.;
  G[2][1] = -0.577350;
  G[2][2] = 0.577350;
  G[3][1] = -0.774597;
  G[3][2] = 0.;
  G[3][3] = 0.774597;

  for (i=0; i<(4*NN*NN*MM*MM); i++)   AA[i]=0;
  saut=-2;
 
  /***** beginning of the computation loop *******/
  
  for (jj=1; jj<=(NN-1)*(MM-1); jj++)
    {
      if (floor((jj-1.0)/(NN-1))==(jj-1.0)/(NN-1))  saut=saut+2;
      xtmp[0]=XY[2*jj-1+saut-1];
      ytmp[0]=XY[2*jj+saut-1];
      xtmp[1]=XY[2*jj+1+saut-1];
      ytmp[1]=XY[2*jj+2+saut-1];
      xtmp[2]=XY[2*jj-1+2*NN+saut-1];
      ytmp[2]=XY[2*jj+2*NN+saut-1];
      xtmp[3]=XY[2*jj+1+2*NN+saut-1];
      ytmp[3]=XY[2*jj+2+2*NN+saut-1];
      for (i=0; i<64; i++)  KK[i]=0.0;
      lambda2=lambda;
      mu2=mu;


      /* GGA */
      if ((activ[0]>0)&&(jj>=(4*fact*(NN-1)+1))&&(jj<=7*fact*(NN-1))) 
    /* Nov 99 */
    /* ajuste pour avoir  6 fibres et 221 noeuds */
	{
	  lambda2 = lambda2 + lambda*(activ[0]/2.5)*4; /* modif. Dec 99 */
	  mu2 = mu2 + mu*(activ[0]/2.5)*4;             /* modif. Dec 99 */
	}
      
      /* GGP */
      if ((activ[1]>0)&&(jj>=(fact*(NN-1)+1))&&(jj<=4*fact*(NN-1)))
	{
	  lambda2=lambda2+lambda*(activ[1]/3)*4; /* modif. Dec 99 */
	  mu2=mu2+mu*(activ[1]/3)*4;             /* modif. Dec 99 */

	  }       
      
      /* HYO */
        if ((activ[2]>0)&&(((jj>3*fact*(NN-1))&&(jj<(7*fact-1)*(NN-1))&&(3*fact<(jj%(NN-1)))&&((jj%(NN-1))<=4*fact))||((jj>=((6*fact-1)*(NN-1)))&&(jj<(7*fact-1)*(NN-1))&&(4*fact<(jj%(NN-1)))&&((jj%(NN-1))<5*fact))||((jj>=3*fact*(NN-1))&&(jj<3*fact*(NN-1)+(NN-1))&&(4*fact<(jj%(NN-1)))&&((jj%(NN-1))<=5*fact))||((jj>=3*fact*(NN-1)+(NN-1))&&(jj<4*fact*(NN-1))&&(4*fact<(jj%(NN-1)))&&((jj%(NN-1))<5*fact))))
	 /* Modifs Dec 99 YP-PP */
	{
	  lambda2 = lambda2+lambda*(activ[2]/7)*15; /* modif. Dec 99 */
	  mu2 = mu2+mu*(activ[2]/7)*15;             /* modif. Dec 99 */
	}
      
      /* STYLO */
     /* if ((activ[3]>0)&&(((jj>4*fact*(NN-1))&&(jj<=(8*fact-1)*(NN-1))&&((3*fact)<(jj%(NN-1)))&&((jj%(NN-1))<=(4*fact)))||((jj>(3*fact-1)*(NN-1))&&(jj<=4*fact*(NN-1))&&((4*fact)<=(jj%(NN-1)))&&((jj%(NN-1))<(5*fact))))) Modifs Nov 99 YP-PP */
      if ((activ[3]>0)&&(((jj>4*fact*(NN-1))&&(jj<=(8*fact-1)*(NN-1))&&((3*fact)<(jj%(NN-1)))&&((jj%(NN-1))<=(4*fact)))||((jj>(3*fact-1)*(NN-1))&&(jj<=4*fact*(NN-1))&&((4*fact)<=(jj%(NN-1)))&&((jj%(NN-1))<(5*fact)))||((jj==4*fact*(NN-1)+4*fact+1)))) /* Modifs Mars 2000 PP */
   {
	  lambda2=lambda2+lambda*(activ[3]/8)*4; /* modif. Dec 99 */
	  mu2=mu2+mu*(activ[3]/8)*4;             /* modif. Dec 99 */

	}
      
      /* SL */
      if ((activ[4]>0)&&(jj>(fact*2*(NN-1)))&&((jj%(NN-1))==0)) /* modif. Dec 99 */
	{
	  lambda2=lambda2+lambda*(activ[4]/1.5)*4; /* modif. Dec 99 */
	  mu2=mu2+mu*(activ[4]/1.5)*4;             /* modif. Dec 99 */
	}
      
      /* VERT */
      if ((activ[5]>0)&&(jj>5*fact*(NN-1)>0)&&(jj<=(8*fact-1)*(NN-1))&&((jj%(NN-1))>=(4*fact-1))&&((jj%(NN-1))<(NN-1)))  /* Modifs Nov 99 YP-PP */
	{
	  stotmp1=floor((jj-4.0*fact*(NN-1)-1)/(3*fact));
	  if (stotmp1-2*floor(stotmp1/2)==1)
	    {
	      lambda2=lambda2+lambda*(activ[5]/0.25); /* modif. Dec 99 */
	      mu2=mu2+mu*(activ[5]/0.25);             /* modif. Dec 99  */
	  	  /*printf("Vert %f %f \n",lambda2, activ[5]);*/
	    }
	}
      
      
      /* if (lambda2>16*lambda)  lambda2=16*lambda; */
      /* if (mu2>16*mu)   mu2=16*mu; */
      
      pfix=0;
      if (jj==NN-1)   pfix=2;
      if ((jj-(NN-1)*floor((jj-0.0)/(NN-1)))==1)   pfix=1;
      /* Pas de traitement special pour les noeuds en contact car ils ne */
      /* sont pas fixes (mouvt de glisse le long du palais */
      /* for (i=0; i<nbcontact; i++) */
 /* 	{*/
	 /*   if (6.0*ncontact[i]/7-6==jj) pfix=3;*/
	 /*   if (6.0*ncontact[i]/7==jj)   pfix=4;*/
      /*	  } */
      
      for (i=1; i<=ordre; i++)
        {
	  for (j=1; j<=ordre; j++)
            {      
	      r=G[ordre][i];
	      s=G[ordre][j];
	      dpsidr[0]=0.25*(s-1);
	      dpsidr[1]=-dpsidr[0];
	      dpsidr[2]=0.25*(-1-s);
	      dpsidr[3]=-dpsidr[2];
	      dpsids[0]=0.25*(r-1);
	      dpsids[1]=0.25*(-1-r);
	      dpsids[2]=-dpsids[0];
	      dpsids[3]=-dpsids[1];

	      stotmp1=0;
	      stotmp2=0;
	      stotmp3=0;
	      stotmp4=0;
	      for (k=0; k<4; k++)   stotmp1=stotmp1+dpsidr[k]*xtmp[k];
	      for (k=0; k<4; k++)   stotmp2=stotmp2+dpsids[k]*ytmp[k];
	      for (k=0; k<4; k++)   stotmp3=stotmp3+dpsids[k]*xtmp[k];
	      for (k=0; k<4; k++)   stotmp4=stotmp4+dpsidr[k]*ytmp[k];
	      detJ=stotmp1*stotmp2-stotmp3*stotmp4;
	      
	      for (k=0; k<4; k++)
		{
		  dpsi[k]=stotmp2*dpsidr[k]-stotmp4*dpsids[k];
		  dpsi[k+4]=stotmp1*dpsids[k]-stotmp3*dpsidr[k];
		}
	      dpsi[8]=0; 
	     
	      for (k=0; k<64; k++)
		{
		  IAfix[k]=IAi[k];
		  IDfix[k]=IDi[k];
		}
	     
	      if (pfix==1)
		{
		  for (k=0; k<16; k++)
		    {
		      IAfix[k]=9;
		      IDfix[k]=9;
		    }
		  for (k=32; k<48; k++)
		    {
		      IAfix[k]=9;
		      IDfix[k]=9;
		    }
		}
	      
	      if (pfix==2)
		{
		  for (k=16; k<32; k++)
		    {
		      IAfix[k]=9;
		      IDfix[k]=9;
		    }
		}
	      
	      if (pfix==3)
		{
		  for (k=32; k<48; k++)
		    {
		      IAfix[k]=9;
		      IDfix[k]=9;
		    }
		}
	      
	      if (pfix==4)
		{
		  for (k=48; k<63; k++)
		    {
		      IAfix[k]=9;
		      IDfix[k]=9;
		    }
		}
	       
	      for (k=0; k<64; k++)
		{
		  A[k]=dpsi[IAfix[k]-1];
		  B[k]=dpsi[IBi[k]-1];
		  C[k]=dpsi[ICi[k]-1];
		  D[k]=dpsi[IDfix[k]-1];
		  E[k]=dpsi[IEi[k]-1];
		}
	   
	      if (detJ>0)  tmpdet=1.0/detJ;
	      else         tmpdet=-1.0/detJ;
	   

	      for (k=0; k<64; k++)
		{
		  KK[k]=KK[k]+H[ordre][i]*H[ordre][j]*tmpdet*(A[k]*(lambda2*B[k]+2*mu2*C[k])+mu2*D[k]*E[k]);
		}
	    }   /* end for i= */
	  
	}      /* end for j= */

      debut=(2*NN*MM)*(2*jj-2+saut)+2*jj-1+saut-1;
      for (i=0; i<8; i++)
	{
	  if (i<=3) indice[i]=debut+i;
	  else      indice[i]=debut+2*NN+i-4;
	  indice[i+8]=indice[i]+2*NN*MM;
	  indice[i+16]=indice[i]+4*NN*MM;
	  indice[i+24]=indice[i]+6*NN*MM;
	}
      for (i=0; i<32; i++)  indice[i+32]=indice[i]+2*NN*(2*NN*MM);

      for (i=0; i<64; i++)  AA[indice[i]]=AA[indice[i]]+KK[i];
    }         /* end for jj= */  
}





