#include <cstdio>
#include <iostream>
#include <cmath>
#include <fstream>
#include <list>
#include <set>
#include <algorithm>
#include <queue>
#include <stack>

using namespace std;

class values
{
public:
	int flow;
	int gres;
	int u,l;
	int zc;
	int kilter;

	long KilterNumber()
	{
		if (zc < 0 || (zc == 0 && flow < l))
			kilter = abs(flow - l);
		else if (zc > 0 || (zc == 0 && flow > u))
			kilter = abs(flow - u);
		else 
			kilter = 0;
		return kilter;
	}
};


class edge
{
public:
	int i,j,c,org;
	values* val;

	edge()
	{
		val = new values(); 
		val->flow = 0;
		val->kilter = 0;
		val->l = val->u = val->zc = 0;
	}

	bool operator<(const edge& rhs) const
	{
		return i < rhs.i;
	}

	bool operator==(const edge& rhs) const
	{
		return i == rhs.i && j == rhs.j;
	}
};


int readDataFromFile(list<edge> &edgelist)
{
	ifstream o;
	o.open("data.in");

	// maximal number of node
	int n;
	o>>n;
	cout<<"Maximal node number: "<<n<<endl;


	edge *tmp;
	while(!o.eof())
	{
		// line has a form of: i j cost u l
		int i,j,c,u,l;
		o>>i; o>>j; o>>c; o>>u; o>>l;
		printf("Edge from %d to %d : lower %d, upper %d, cost %d\n",i,j,l,u,c);
		tmp = new edge();
		tmp->i = i;
		tmp->j = j;
		tmp->c = c;
		tmp->val->zc = -c;
		tmp->val->l = l;
		tmp->val->u = u;
		tmp->val->KilterNumber();

		edgelist.push_back(*tmp);
	}
	return n;
}

int DFS(vector<list<edge>> resgraph, int p, int q, bool *visited, list<int> &path)
{
	cout<<"DFS: " << p <<" to " << q<<endl;
	int res = -1, val;
	list<int> toDest;
	visited[p] = true;
	for (list<edge>::iterator it = resgraph[p].begin(); it != resgraph[p].end(); it++)
	{
		if ( !visited[it->j] )
		{
			if (it->j == q)
			{
				res = it->val->flow;
				path.push_back(it->i);
				path.push_back(it->j);
				break;
			}
			else
			{
				val = DFS(resgraph, it->j, q, visited,toDest);
				if ( val > -1 )
				{
					res = min(val , it->val->flow);
					path.push_back(it->i);
					for (list<int>::iterator it2 = toDest.begin(); it2 != toDest.end(); it2++)
						path.push_back(*it2);
					break;
				}
			}
		}
	}

	return res;
}


int DFS2(vector<list<edge>> resgraph, int p, int q, bool *visited, list<int> &path3)
{
	cout<<"DFS: " << p <<" to " << q<<endl;
	int res = -1, val;
	list<int> toDest;
	visited[p] = true;
	stack< list<edge>::iterator > stos;
	for (list<edge>::iterator it = resgraph[p].begin(); it != resgraph[p].end(); it++)
	{
		stos.push(it);
	}

	stack<int> wynik;
	stack<int> path;
	stack<int> visited2;
	visited2.push(p);
	while(!stos.empty())
	{
		list<edge>::iterator it = stos.top();
		stos.pop();

		for (list<edge>::iterator it2 = resgraph[it->j].begin(); it2 != resgraph[it->j].end(); it2++)
		{
			if (!visited[it->j])
				stos.push(it2);
		}

		if ( !visited[it->j] )
		{
			if (it->j == q)
			{
				wynik.push(it->val->flow);
				break;
			}
		}
	}
	while (!visited2.empty())
	{
		int vi = visited2.top();
		visited2.pop();

		if ( vi == q)
		{
			// Save and move downstairs
		}

	}

	return res;
}

void computeResGraph(vector<list<edge>> &resgraph,list<edge> &edgelist)
{
	for (list<edge>::iterator it = edgelist.begin(); it != edgelist.end(); it++)
	{
		edge* x = new edge();
		x->i = it->i;
		x->j = it->j;

		x->val->zc = it->val->zc;
		x->val->l = it->val->l;
		x->val->u = it->val->u;

		if ( (x->i == 3 && x->j == 9) || (x->i == 9 && x->j == 3))
		{
			cout<<x->i<<" "<<x->j<<" "<<x->val->zc<<" "<<x->val->l<<" "<<x->val->u<<" F: " << it->val->flow<<endl;
		}

		// zc >= 0 && flow < u 
		if( (it)->val->zc >=0 && (it)->val->flow < (it)->val->u )
		{
			// G(i,j) = u(i,j) - flow(i,j);
			x->val->flow = (it)->val->u - (it)->val->flow;
			resgraph[x->i].push_back(*x);
		}

		x = new edge();
		x->i = it->i;
		x->j = it->j;

		x->val->zc = it->val->zc;
		x->val->l = it->val->l;
		x->val->u = it->val->u;

		// zc <= 0 && flow > l
		if ( (it)->val->zc <=0 && (it)->val->flow > (it)->val->l ) 
		{
			//G(j,i) = flow(i,j) - l(i,j);
			x->i = it->j;
			x->j = it->i;
			x->val->flow = (it)->val->flow - (it)->val->l;
			x->org = 0;
			resgraph[it->j].push_back(*x);
		}
		// zc <= 0 && flow < l    
		else if ( (it)->val->zc <0 && (it)->val->flow < (it)->val->l )
		{
			//G(i,j) = l(i,j) - flow(i,j);
			x->val->flow = (it)->val->l - (it)->val->flow;
			resgraph[x->i].push_back(*x);
		}
		// zc > 0 && flow > u
		else if ( (it)->val->zc >0 && (it)->val->flow > (it)->val->u )
		{
			//	G(j,i) = flow(i,j) - u(i,j);
			x->i = it->j;
			x->j = it->i;
			x->val->flow = (it)->val->flow - (it)->val->u;
			x->org = 0;
			resgraph[it->j].push_back(*x);
		}
	}
}

void showResGraph(vector<list<edge>> &resgraph, int n, list<edge>::iterator edge_we_work)
{
	cout << "|| Residual graph structure"<<endl;
	for (int i=1;i<=n;i++)
	{
		for (list<edge>::iterator it = resgraph[i].begin(); it != resgraph[i].end(); it++)
		{
			if ( i == edge_we_work->i && it->j == edge_we_work->j )
			{
				it->val->flow = 0;
			}
			cout<<"Res Graph: from " <<i <<" to " << it->j << " with max flow : " << it->val->flow <<endl;
		}
	}
	cout << "|| Residual graph end"<<endl;
}

void showResGraph(vector<list<edge>> &resgraph, int n)
{
	cout << "|| Residual graph structure"<<endl;
	for (int i=1;i<=n;i++)
	{
		for (list<edge>::iterator it = resgraph[i].begin(); it != resgraph[i].end(); it++)
		{
			cout<<"Res Graph: from " <<i <<" to " << it->j << " with flow : " << it->val->flow <<endl;
		}
	}
	cout << "|| Residual graph end"<<endl;
}

void computeIllEdges(list< list<edge>::iterator > &illedges,list<edge> &edgelist)
{
	for(list<edge>::iterator it = edgelist.begin(); it != edgelist.end(); it++)
	{
		if ( (*it).val->kilter != 0 )
		{
			illedges.push_back(it);
		}
	}
}

// TO DO :
//	* updating residual graph
//	* iterators to global list
//  * DFS with reccurances


int main()
{
	// All edges in network
	list<edge> edgelist;
	// illedges -> iterators to the global list
	list< list<edge>::iterator > illedges;
	/// Parsing input data
	int n = readDataFromFile(edgelist);

	// Creating a list of illedges to cure
	computeIllEdges(illedges,edgelist);
	if (illedges.empty())
	{
		cout<<"Optimal solution"<<endl;
		exit(-1);
	}

	// Tworzenia grafu residualnego - nastêpne kroki bêd¹ go jedynie update'owa³y
	// Residual graph
	vector<list<edge>> resgraph;
	list<edge> *tmaa;
	for (int i=0;i<=n;i++)
	{
		tmaa = new list<edge>();	
		resgraph.push_back(*tmaa);
	}
	computeResGraph(resgraph,edgelist);



	// Main program action:
	// 1. Find ill-edge with maximum Kilter number
	// 2. Try to create a flow by the residual graph - primal part 
	// 3. Relax constraints - dual method


	while(!illedges.empty())
	{
		int suma = 0;
		for(list<edge>::iterator it = edgelist.begin(); it != edgelist.end(); it++)
			suma+=it->val->kilter;
		cout<<"KILTER SUM :"<<suma<<endl;

		int yyyy;
		cin >>yyyy;

		list<edge>::iterator edge_we_work = *illedges.begin();
		int max  = edge_we_work->val->kilter;
		for (list< list<edge>::iterator >::iterator it = illedges.begin(); it != illedges.end(); ++it)
		{
			if( (*it)->val->kilter > max)
			{
				max = (*it)->val->kilter;
				edge_we_work = *it;
			}
		}
		int p = edge_we_work->i, q = edge_we_work->j;

		cout<<"OutKilter arc: ("<<p<<", "<<q<<")"<<endl;
		// G(p,q) = 0
		int needed = edge_we_work->val->kilter;
		edge_we_work->val->gres = 0;

		showResGraph(resgraph,n, edge_we_work);

		// DFS z q do p
		bool *visited = new bool [n+1];
		memset(visited,false,sizeof(bool)*(n+1));
		list<int> path;

		// DFS(vector<list<edge>> resgraph, int p, int q, bool *visited, list<int> &path)
		int s = DFS(resgraph, q, p, visited, path);

		cout<<"DFS cost: "<<s<<" min(s,needed)="<<min(s,needed)<<endl;
		for (list<int>::iterator it = path.begin(); it != path.end(); ++it)
		{
			cout<<"PATH: "<<*it<<endl;
		}

		cout<<"Decision: PRIMAL vs DUAL"<<endl;

		//
		// PRIMAL PHASE
		//
		if ( s != -1)
		{
			cout<<"PRIMAL"<<endl;
			edge_we_work->val->flow = edge_we_work->val->flow + min(s,needed);
			edge_we_work->val->KilterNumber();
			if (edge_we_work->val->kilter == 0)
			{
				illedges.remove(edge_we_work);
			}

			// Recal Kilter for the rest of edges
			int last = q;
			for ( list<int>::iterator it = path.begin(); it != path.end(); ++it)
			{
				if ( it == path.begin() )
					++it;
				if ( it == path.end())
					break;
				list<edge>::iterator z;
				for ( z = edgelist.begin(); z != edgelist.end(); ++z)
				{
					if ( (z->i == last && z->j == *it) || (z->j == last && z->i == *it))
						break;
				}

				if (z->org) 
					z->val->flow = z->val->flow + min(s,needed);
				else
					z->val->flow = z->val->flow - min(s,needed);

				if(z->val->kilter != 0)
				{
					z->val->KilterNumber();
					if (z->val->kilter == 0)
						illedges.remove(z);
				}
				else
					z->val->KilterNumber();

				last = *it;
			}
			cout<<"Ending graph update"<<endl;
		}
		//
		// DUAL PHASE
		//
		else
		{
			cout<<"DUAL !"<<endl;

			for (int i=1;i<=n;i++)
				cout<<visited[i]<<" ";
			cout<<endl;

			int theta1 = std::numeric_limits<int>::max(), theta2 = std::numeric_limits<int>::max();
			for (list<edge>::iterator it = edgelist.begin(); it != edgelist.end(); ++it)
			{
				cout<<"D: "<<it->i<< " "<<it->j<<"  | "<<it->val->l<<" "<<it->val->u<<" || "<< it->val->zc<<endl;
				if (visited[it->i] && !visited[it->j] &&  (it->val->zc < 0) && (it->val->flow <= it->val->u) )
				{
					theta1 = min (theta1, -it->val->zc);
				}

				else if (!visited[it->i] && visited[it->j] && (it->val->zc > 0) && (it->val->flow >= it->val->l) )
				{
					theta2 = min(theta2, it->val->zc);
				}

			}
			cout<<"Thetas: "<<theta1<<" & "<<theta2<<endl;

			// Dual problem has infinite solution
			if ( theta1 == std::numeric_limits<int>::max() )
			{
				cout<<"No feasible solution to primal problem"<<endl;
			}
			else
			{
				int theta = min(theta1, theta2);
				
				// Relaxation procedure
				for ( list<edge>::iterator it = edgelist.begin(); it != edgelist.end(); ++it)
				{
					if ( visited[it->i] && !visited[it->j] )
					{
						it->val->zc += theta;
						if ( it->val->kilter != 0 )
						{
							it->val->KilterNumber();
							if ( it->val->kilter == 0 )
								illedges.remove(it);
						}
						else
							it->val->KilterNumber();
					}
					else if ( !visited[it->i] && visited[it->j] )
					{

						it->val->zc -= theta;
						if ( it->val->kilter != 0 )
						{
							it->val->KilterNumber();
							if ( it->val->kilter == 0 )
								illedges.remove(it);
						}
						else
							it->val->KilterNumber();
					}

				}

			}

		}


		// Update grafu residualnego
		for (int i=0;i<=n;i++)
		{
			resgraph[i].clear();
		}

		for (list< edge>::iterator z = edgelist.begin(); z != edgelist.end(); ++z)
		{
			if (z->i == 3 && z->j == 9)
				cout<<"FL : "<<z->val->flow<<endl;
		}


		computeResGraph(resgraph,edgelist);
		showResGraph(resgraph,n);

		for (list<edge>::iterator it = edgelist.begin(); it != edgelist.end(); it++)
		{
			//cout<<"from " <<it->i <<" to " << it->j << "\t flow : " << it->val->flow <<"\t zc :"<< it->val->zc<<endl;
		}

		// ILE ITERACJI
		//break;
	}

	cout<<"Computed result"<<endl;

	int koszt = 0;

	cout << "++ GRAPH"<<endl;
	for (list<edge>::iterator it = edgelist.begin(); it != edgelist.end(); it++)
	{
		koszt += (it->val->flow * it->c);
		cout<<"from " <<it->i <<" to " << it->j << "\t flow : " << it->val->flow <<"\t zc :"<< it->val->zc<<endl;
	}
	cout << "++ GRAPH"<<endl;

	cout<<"Sumaryczny koszt: "<<koszt<<endl;

	// Program ending
	int xxxxxxx;
	cin>>xxxxxxx;
}