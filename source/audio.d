module audio;

import imps,derelict.util.exception;

private immutable(ALfloat)[] listenerPos = [0.0,0.0,0.0];
private immutable(ALfloat)[] listenerVel = [0.0,0.0,0.0];
private immutable(ALfloat)[] listenerOri = [0.0,0.0,1.0, 0.0,1.0,0.0];

private immutable(ALfloat)[] srcPos = [0.0,0.0,1.0];

private ALCdevice*  dev;
private ALCcontext* ctx;

ShouldThrow symFunc(string name)
{
	return ShouldThrow.No;
}

public void InitAudio()
{
	DerelictVorbisFile.missingSymbolCallback = &symFunc;
	DerelictVorbisFile.load();
	DerelictAL.load();

	dev = alcOpenDevice(null);
	if(!dev){throw new Error("OpenAL initialization problems. [-2]");}
	ctx = alcCreateContext(dev,null);
	alcMakeContextCurrent(ctx);
	if(!ctx){throw new Error("OpenAL initialization problems. [-1]");}

	alListenerfv(AL_POSITION, listenerPos.ptr);
	alListenerfv(AL_VELOCITY, listenerVel.ptr);
	alListenerfv(AL_ORIENTATION, listenerOri.ptr);
	if(alGetError()!=AL_NO_ERROR){throw new Error("OpenAL initialization problems. [1]");}
}

public void QuitAudio()
{
	if(ctx)alcDestroyContext(ctx);
	if(dev)alcCloseDevice(dev);
}

class Audio
{
	public ALuint sourceId=0xFFFFFFFF, bufferId=0xFFFFFFFF;

	protected ALuint format,freq;

	public this(string fname)
	{
		alGenSources(1,&sourceId);
		if(alGetError()!=AL_NO_ERROR){throw new Error("OpenAL cannot create source.");}
		alSourcefv(sourceId, AL_POSITION, cast(const(float)*)(srcPos.ptr));

		alGenBuffers(1,&bufferId);
		if(alGetError()!=AL_NO_ERROR){throw new Error("OpenAL cannot create buffer.");}

		loadFile(fname);
	}

	~this()
	{
		if(sourceId!=0xFFFFFFFF)alDeleteSources(1,&sourceId);
		if(bufferId!=0xFFFFFFFF)alDeleteBuffers(1,&bufferId);
	}

	public void Play()
	{
		alSourcePlay(sourceId);
	}

	public void Pause()
	{
		alSourcePause(sourceId);
	}

	public void Stop()
	{
		alSourceStop(sourceId);
	}

	public @property void Loop(bool x)
	{
		alSourcei(sourceId,AL_LOOPING, x?AL_TRUE:AL_FALSE );
	}

	public bool Playing()
	{
		ALint state;
		alGetSourcei(sourceId,AL_SOURCE_STATE,&state);
		return (state==AL_PLAYING);
	}

	protected void loadFile(string fname)
	{
		import std.c.stdio;
		int indian=((endian==Endian.bigEndian)?1:0), bitStream;
		long bytes;
		byte[] array;
		array.length=16_777_216;
		size_t alen=0;
		vorbis_info* pInfo;
		OggVorbis_File *of = new OggVorbis_File();
		if(ov_fopen(fname.toStringz(),of)!=0)throw new Error("Error opening "~fname~" for ogg decoding.");
		pInfo = ov_info(of,-1);
		if(pInfo.channels==1)
			format = AL_FORMAT_MONO16;
		else
			format = AL_FORMAT_STEREO16;
		freq = pInfo.rate;
		do
		{
			bytes = ov_read(of, &array[alen], cast(int)(array.length-alen), indian, 2, 1, &bitStream);
			alen+=bytes;
		}while(bytes>0);
		ov_clear(of);
		alBufferData(bufferId,cast(int)format,&array[0],cast(int)alen,cast(int)freq);
		alSourcei(sourceId, AL_BUFFER, bufferId);
	}
}

