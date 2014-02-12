using UnityEngine;
using System.Collections;
using Pathfinding;

public class PathfindingScript : MonoBehaviour {
	
	public Transform target;
	public float speed;
	public float nextWPDistance;
	private int currentWP = 0;
	public Path path;
	public float minStopDist;
	public Transform enemyTarget;
	public Vector3 pp;
	Seeker seeker;
	CharacterController cc;
	public Animator anim;
	
	// Use this for initialization
	void Start () {
		cc = GetComponent<CharacterController> ();
		seeker = GetComponent<Seeker> ();
		if (tag == "Colony")
		{
			try{target = GameObject.Find("Empire Nexus").transform;}
			catch{}

		}
		if (tag == "Empire")
		{
			try{target = GameObject.Find("Colony Nexus").transform;}
			catch{}

		}

		try{seeker.StartPath (transform.position, target.position, OnPathComplete);}
		catch{}
		currentWP = 0;
	}
	
	void OnPathComplete(Path p)
	{
		if (!p.error)
		{
			path = p;
		}
	}
	
	// Update is called once per frame
	void Update () {
		if (enemyTarget == null)
		{
			if (path != null)
			{
				if (currentWP >= path.vectorPath.Count)
				{
					path = null;
					return;
				}
				if (anim != null)
					anim.SetBool("Locomotion", true);
				Vector3 lookTarget = new Vector3(path.vectorPath[currentWP].x, this.transform.position.y, path.vectorPath[currentWP].z);
				transform.LookAt(lookTarget);
				//Quaternion temp = new Quaternion(0,transform.rotation.y, 0,0);
				//transform.rotation = temp;
				Vector3 dir = (path.vectorPath[currentWP] - transform.position).normalized;
				dir *= speed;
				cc.Move (dir  * Time.deltaTime);
				if (Vector3.Distance(transform.position, path.vectorPath[currentWP]) < nextWPDistance)
				{

					currentWP++;

					return;
				}
				if (pp == transform.position)
				{
					Vector3 lookTarget2 = new Vector3(target.position.x, this.transform.position.y, target.position.z);
					transform.LookAt(lookTarget2);
					//Quaternion temp1 = new Quaternion(0,transform.rotation.y, 0,0);
					//transform.rotation = temp1;
					float temp5 = Random.Range (-1,1);
					if(temp5 > 0 )
					{
						cc.Move(-transform.right * Time.deltaTime);
					}
					else
						cc.Move(transform.right * Time.deltaTime);
				}
				pp = transform.position;
			}
		}
		else
		{
			if (anim != null)
				anim.SetBool("Locomotion", false);
			Vector3 lookTarget3 = new Vector3(enemyTarget.position.x, this.transform.position.y, enemyTarget.position.z);
			transform.LookAt(lookTarget3);
			//Quaternion temp2 = new Quaternion(0,transform.rotation.y, 0,0);
			//transform.rotation = temp2;
		}
	}
}
