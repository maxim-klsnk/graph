#include "Interpolator.hpp"
#include <exception>
#include <cstdio>
#include <cmath>
#include <QDebug>

int Interpolator::pointsCount () const
{
	return _points.size();
}

void Interpolator::setPointsCount (int count)
{
	if (count < _points.size())
	{
		_points.erase(_points.begin() + count, _points.end());
	}
	else if (count > _points.size())
	{
		for (int i = _points.size(); i < count; ++i)
		{
			_points.push_back(Point{0, 0});
		}
	}

}

void Interpolator::setPointAt (int pos, float x, float y)
{
	_points[pos] = Point{x, y};
}

// Реализация метода взята здесь:
// http://www.alexeypetrov.narod.ru/C/sqr_less_about.html
// Незначительно измененна, что бы не использовать
// глобальные переменные и дополненна
void Interpolator::polynom3xPrepare ()
{
	qDebug() << "Debug: polynom3xPrepare runned";
	QList<float> a;
	float *b, *x, *y, **sums;
	int N, K;
	K = 3;
	N = _points.size();

	//N - number of data points
	//K - polinom power
	//K<=N

	if (K > N)
	{
		throw std::runtime_error(
			"plynom3xApproximation: K > N");
	}

   int i=0,j=0, k=0;

   //allocate memory for matrixes
   {
	   int i,j,k;
	   b = new float[K+1];
	   x = new float[N];
	   y = new float[N];
	   sums = new float*[K+1];
	   if(x==NULL || y==NULL || sums==NULL){
		   printf("\nNot enough memory to allocate. N=%d, K=%d\n", N, K);
		   exit(-1);
	   }
	   for(i=0; i<K+1; i++){
		   sums[i] = new float[K+1];
		   if(sums[i]==NULL){
		   printf("\nNot enough memory to allocate for %d equations.\n", K+1);
		   }
	   }
	   for(i=0; i<K+1; i++){
		   a.push_back(0);
		   b[i]=0;
		   for(j=0; j<K+1; j++){
		   sums[i][j] = 0;
		   }
	   }
	   for(k=0; k<N; k++){
		   x[k]=0;
		   y[k]=0;
	   }
   }

   //read data
   {
	   int i=0,j=0, k=0;
	   for(k=0; k<N; k++){
		   Point p = _points.at(k);
		   x[k] = p.x;
		   y[k] = p.y;

		   qDebug() << "Set point " << x[k] << " " << y[k];
	   }
	   //init square sums matrix
	   for(i=0; i<K+1; i++){
			   for(j=0; j<K+1; j++){
			   sums[i][j] = 0;
			   for(k=0; k<N; k++){
				   sums[i][j] += pow(x[k], i+j);
			   }
		   }
	   }
	   //init free coefficients column
	   for(i=0; i<K+1; i++){
		   for(k=0; k<N; k++){
			   b[i] += pow(x[k], i) * y[k];
		   }
	   }
   }

   //check if there are 0 on main diagonal and exchange rows in that case
   {
	   int i, j, k;
	   float temp=0;
	   for(i=0; i<K+1; i++){
		   if(sums[i][i]==0){
			   for(j=0; j<K+1; j++){
				   if(j==i) continue;
				   if(sums[j][i] !=0 && sums[i][j]!=0){
				   for(k=0; k<K+1; k++){
					   temp = sums[j][k];
					   sums[j][k] = sums[i][k];
					   sums[i][k] = temp;
				   }
				   temp = b[j];
				   b[j] = b[i];
				   b[i] = temp;
				   break;
				   }
			   }
		   }
	   }
   }

   //process rows
   for(k=0; k<K+1; k++){
	   for(i=k+1; i<K+1; i++){
		   if(sums[k][k]==0){
			   throw std::runtime_error(
				   "polynom3xApproximation: Solution is not exist.");
		   }
		   float M = sums[i][k] / sums[k][k];
		   for(j=k; j<K+1; j++){
			   sums[i][j] -= M * sums[k][j];
		   }
		   b[i] -= M*b[k];
	   }
   }

   for(i=(K+1)-1; i>=0; i--){
	   float s = 0;
	   for(j = i; j<K+1; j++){
			s = s + sums[i][j]*a[j];
	   }
	   a[i] = (b[i] - s) / sums[i][i];
   }

   //free memory for matrixes
   {
	   int i;
	   for(i=0; i<K+1; i++){
		   delete [] sums[i];
	   }
	   delete [] b;
	   delete [] x;
	   delete [] y;
	   delete [] sums;
   }

   // write coeficient cache
   _polynom3xCoef = a;
}

float Interpolator::polynom3xXtoY (float x) const
{
	qDebug() << "Debug: polynom3xXtoY runned";
	if (_polynom3xCoef.isEmpty())
	{
		throw std::runtime_error(
			"polynom3xXtoY: coeficient cache is empty");
	}
	float y = 0;
	for (int i = 0; i <= 3; ++i)
	{
		y += (_polynom3xCoef[i] * pow(x, i));
	}
	return y;
}

float Interpolator::lagrangeInterpolationXtoY (float x) const
{

	double result = 0.0;

	for (int i = 0; i < _points.size(); i++)
	{
		double P = 1.0;

		for (int j = 0; j < _points.size(); j++)
			if (j != i)
				P *= (x - _points[j].x)/ (_points[i].x - _points[j].x);

		result += P * _points[i].y;
	}

	return result;
}
