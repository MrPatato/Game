public class move : MonoBehaviour {

	public float upforce = 900f;
	public KeyCode jumpkey;
	public float move2;
	public int playerspeed = 10;
	private bool facingright = true;
	public bool dead = false;
	public bool isGrounded = false;
	public move instance;
	public static int lives = 3;
	public Text livesleft;
	public bool died;
	public KeyCode Restart;
	public static bool Go = false;
	

	private Rigidbody2D rb2d;
	

	void Update () 
	{	
		inair ();
		Kill ();
		playermove ();
		if (Input.GetButtonDown ("Jump") && isGrounded == true) 
		{
			jump ();
		}
		if (gameObject.transform.position.y < -6) 
		{
			died = true;
		}
		if (died == true)
		{
			StartCoroutine ("die");
		}
		if (lives == 0)
		{
			lives --;
			Go = true;
			SceneManager.LoadScene ("GameOver");
		}
		if (Input.GetButtonDown ("Restart") && Go == true)
		{
			lives = 3;
			SceneManager.LoadScene ("start");
			Go = false;
		}
	}
	
	IEnumerator die ()
	{ 
		lives --;
		livesleft.text = "Lives Left: " + lives.ToString ();
		SceneManager.LoadScene ("start");
		yield return null;
	}

	void Start ()
	{
		rb2d = GetComponent<Rigidbody2D> ();
		died = false;
		if (lives < 4)
		{
			livesleft.text = "Lives Left: " + lives.ToString ();
		}
	}		

	public void jump () 
	{	
		rb2d.velocity = Vector2.zero;
		rb2d.AddForce (new Vector2(0, upforce));
		isGrounded = false;
	}

	void playermove ()
	{
		move2 = Input.GetAxis("Horizontal");
		if (move2 < 0.0f && facingright == true)
		{
			Flip ();
		}
		else if (move2 > 0.0f && facingright == false)
		{
			Flip ();
		}
		gameObject.GetComponent<Rigidbody2D> ().velocity = new Vector2 (move2 * playerspeed, gameObject.GetComponent<Rigidbody2D> ().velocity.y);
	}

	void Flip ()
	{
		facingright = !facingright;
		Vector2 localScale = gameObject.transform.localScale;
		localScale.x *= -1;
		transform.localScale = localScale;
	}

	void OnCollisionEnter2D (Collision2D col)
	{
		if (col.gameObject.tag == "Ground")
		{
			isGrounded = true;
		}
		else if (col.gameObject.tag == "Wall")
		{
			isGrounded = true;
		}
		else if (col.gameObject.tag == "enemy")
		{
			StartCoroutine ("die");
		}
		else if (col.gameObject.tag == "winner")
		{
			lives = 5;
			Go = true;
			SceneManager.LoadScene ("Win");
		}
	}	

	void Awake () 
	{
		if(instance == null) {
			instance = this;
		} else if(instance !=this)
		{
			Destroy(gameObject);
		}
	}
	
	void Kill ()
	{
		RaycastHit2D hit = Physics2D.Raycast (transform.position, Vector2.down);
		if (hit != null && hit.collider != null && hit.distance < 0.775f && hit.collider.tag == "enemy")
		{
			jump ();
			Destroy (hit.collider.gameObject);
			GameObject.FindGameObjectWithTag ("score").GetComponent<Score>().Enemy();
		}
	}
	void inair ()
	{
		RaycastHit2D hit = Physics2D.Raycast (transform.position, Vector2.down);
		if (hit != null && hit.collider != null && hit.distance > 0.5f)
		{
			isGrounded = false;
		}
	}
