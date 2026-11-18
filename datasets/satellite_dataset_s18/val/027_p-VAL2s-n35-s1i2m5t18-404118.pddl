(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image4 - mode
	spectrograph0 - mode
	image2 - mode
	image3 - mode
	thermograph1 - mode
	Star0 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star5 - direction
	Star6 - direction
	Star8 - direction
	GroundStation10 - direction
	Star12 - direction
	GroundStation13 - direction
	Star14 - direction
	GroundStation15 - direction
	Star17 - direction
	Star1 - direction
	Star11 - direction
	Star7 - direction
	Star16 - direction
	GroundStation9 - direction
	GroundStation4 - direction
	Phenomenon18 - direction
	Star19 - direction
	Phenomenon20 - direction
	Planet21 - direction
	Phenomenon22 - direction
	Phenomenon23 - direction
	Planet24 - direction
	Phenomenon25 - direction
	Planet26 - direction
	Phenomenon27 - direction
)
(:init
	(supports instrument0 image4)
	(supports instrument0 thermograph1)
	(supports instrument0 image3)
	(supports instrument0 image2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 Star16)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star11)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star17)
)
(:goal (and
	(pointing satellite0 Star17)
	(have_image Phenomenon18 thermograph1)
	(have_image Star19 image4)
	(have_image Phenomenon20 thermograph1)
	(have_image Planet21 image3)
	(have_image Phenomenon22 image2)
	(have_image Phenomenon23 spectrograph0)
	(have_image Planet24 image2)
	(have_image Phenomenon25 image4)
	(have_image Planet26 image3)
	(have_image Phenomenon27 spectrograph0)
))

)
